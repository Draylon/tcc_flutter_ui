import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../api/call.dart';
import '../shared/components/CardTopicContainer.dart';
import '../shared/components/LoadingFailed.dart';
import '../shared/components/LoadingIndicator.dart';
import '../shared/control/LocationHandler.dart';

/*enum CardContentDataType{
  Tags,SensorData,WithinCity,NearbyCities;
  @override
  String toString(){
    return name;
  }
  String toLower() => toString().toLowerCase();
  static CardContentDataType? fromString(String s){
    for (CardContentDataType element in CardContentDataType.values) {
      if(element.toLower()==s.toLowerCase())
        return element;
    }
  }
}

class CardContentRequestParameters{
  static String from(CardContentDataType d){
    switch(d){
      case CardContentDataType.Tags:
        return "locations_by_tag_nearby;locationmetrics_by_tag_nearby;sensordatacloud_by_tag_nearby";
      case CardContentDataType.SensorData:
        return "realtime_index_location;last24h_graph_location;comparison_yearly_monthly;averages_by_daterange;averages_by_something";
      case CardContentDataType.WithinCity:
        return "";
      case CardContentDataType.NearbyCities:
        return "";
      default:
        return "<null>";
    }
  }
}*/

class ViewCardContent extends StatefulWidget{
  //CardContentDataType type;
  String? db_id;
  String? title;
  String? description;
  String? detailed;

  /* exibits: {
    _id: 645023174ce832b6deea94e4,
    dataset_interval: last1h,
    dataset_data_type: all_related_tags;traffic_info;crowd_info,
    data_display: radial,
    data_parsing_functions: [tags_are_level_percentage]
  }*/

  ViewCardContent({Key? key,this.db_id,this.title,this.description,this.detailed,}):super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewCardContentState();
}

class _ViewCardContentState extends State<ViewCardContent>{
  @override
  Widget build(BuildContext context) => _buildCardContent();

  @override
  void initState() {
    super.initState();
    _fetch_card_data();
    LocationHandler.locationDataNotifier.addListener(() {
      fetchFirst?_fetch_card_data():null;
    });
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    super.dispose();
  }

  //late LocationData? _curr_location;
  _fetch_latitude_longitude(/*{bool precision=false}*/) async {
    //bool _locationAvaliable=false;
    // check permission
    print("check permission");

    if(!LocationHandler.locationAvaliable) {
      await LocationHandler.checkGPSPermission().then((value) {
        LocationHandler.locationAvaliable = value == PermissionStatus.granted;
      }, onError: (e) {
        print("Error on GPS permission");
        print(e);
      });
    }

    //retrieve coordinates
    //LocationData? curr_location;
    if(LocationHandler.locationAvaliable){
      print("retrieve coordinates");
      await LocationHandler.updateGlobalGPS(prompt: false).then((value) {
        /*setState(() {
          _curr_location=value;
        });*/
      },onError: (e){
        LocationHandler.locationAvaliable=false;
        print("Error on GPS Location retrieval");print(e);
      });

      /*setState(() {
        _curr_location==null?_locationAvaliable=false:null;
      });*/

    }else{
      print("location unavailable on card content, sticking to whois data");
      Map<String,dynamic> whois_json;
      String whois_params ='latitude,longitude';

      await LocationHandler.cached_isp_data(whois_params).then((whois_response) {
        whois_json = whois_response;
        //_curr_location = LocationData.fromMap(whois_json);
        LocationHandler.defineLocationManually(LocationData.fromMap(whois_json));
        return true;
      }, onError: (e) {
        print("Error on whois fetch:");
        print(e);
        //setState((){failureMessage="Error on whois fetch";menuLoaded=1;});
        //return false;
      });
    }
  }

  bool fetchFirst=false;
  _fetch_card_data() async{
    List<dynamic> azure_json=[];

    if(!LocationHandler.locationAvaliable) await _fetch_latitude_longitude();

    // substituir essa chamada de queryFields estático por um request na
    // api de /api/ui_data/$tags pra pegar uma lista de métodos novos disponíveis
    // para o tópico de tags

    await ApiRequests.get("/api/v1/data/feed/${widget.db_id}",{
      "location":"{\"latitude\":${LocationHandler.locationData?.latitude},\"longitude\":${LocationHandler.locationData?.longitude}}",
      /*
      locations_by_tag_nearby             Local que possui a tag. Mostrar 3 primeiros, 4° botão "carregar o resto" se tiver mais. "carregar cidades proximas" se acabar.
      location_metrics_by_tag_nearby      "Praias estão de acordo com a especificação da maioria dos dados obtidos". Essa parte é mais 'informação' do q dados.
      sensor_data_cloud_by_tag_nearby     "quais são os tipos de dados obtidos dessa região."
      */

    }).then((api_response) {
      print("Request completed");
      if (api_response.statusCode == 200) {
        try{
          print(api_response);
          azure_json = json.decode(api_response.body);
          cardTopics.setPassthrough(_state_callback_passthrough);
          cardTopics.initializer(
              widget.title??"no title",
              widget.detailed??"no details",
              widget.description??"no description",
              azure_json,context
          );
          setState(() {
            menuLoaded=2;
            //azure_json.map((e) => ExibitCard.fromJson(e)).toList();
          });
        }on Exception catch(e){
          print(e);
          setState((){failureMessage="API returned invalid data";menuLoaded=1;});
        }
      }else{
        print("did not complete successfully");
        setState((){failureMessage="API returned invalid code";menuLoaded=1;});
      }
      fetchFirst=true;
      return true;
    },onError:(e) {
      print("Error on API fetch:");print(e);
      setState((){failureMessage="Serviço com problemas";menuLoaded=1;});
      //return Future.error("Api Error");
      fetchFirst=true;
      return false;
    });
  }

  void _state_callback_passthrough(Function lmao){
    setState(() {
      lmao.call();
    });
  }

  int menuLoaded=0;
  String failureMessage="Loading Failed!\nPlease refresh";
  CardTopicContainer cardTopics = CardTopicContainer();
  //List<CardTopicFragment> card_topics_list = [];

  _buildCardContent(){
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx,isScrolled)=>[
          SliverAppBar(
            title: Container(
              padding: const EdgeInsets.fromLTRB(15, 0,15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.title ?? "No Title",style: const TextStyle(
                    letterSpacing: 3,
                    //color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  )),
                ],
              ),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blueGrey,
          )
        ],
        body:
        menuLoaded==0?
        const LoadingIndicator()
            :menuLoaded==1?
        LoadingFailed(message: failureMessage,refreshOption: () {
          return _fetch_card_data();
        },)
            :Padding(
              padding: EdgeInsets.fromLTRB(0,0,0,80),
              child: RefreshIndicator(
                displacement: 80,
                onRefresh:(){return _fetch_card_data();},
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15,0,15,0),
                  itemCount: cardTopics.length(),
                  itemBuilder: (BuildContext context, int index) => cardTopics.item(index),
                ),
              ),
        ),
      ),

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:FloatingActionButton(
        //onPressed: ()=>ScaffoldMessenger.of(context).showSnackBar(settingsMarker), // liberar logo settings <=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=
        onPressed: () async =>{
          //edit cards position??
        },
        child: const Icon(Icons.settings),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Theme.of(context).bottomAppBarColor,
        child: IconTheme(
            data: const IconThemeData(
              color: Colors.white,
              size: 26,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                alignment: Alignment.topLeft,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // não sei oq por aqui kkkk
                      IconButton(onPressed: (){
                        //sensor data?
                      }, icon: const Icon(Icons.cloud_queue_sharp,),),

                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );

    // começar a fazer o request sobre o tipo de dado
    // pegar o layout de interface desenhado pra esse tipo
    // fazer o parser do layout
    // alinhar um jeito de categorizar a informação no layout
    // reorganização custom de layout? ( salvar o layout que vier no cache daí )
    //

    // Static UIs

    // example: {tags: [Praia, Parque, Floresta, Rio], sensor_data: [CO2], within_city: [Rio da Prata], nearby_cities: [São francisco do sul]}

    // Tags: Location type (within city?)
    // Show list of all those places within the city with any of the tags selected
    //    Show metrics for all those regions
    //    Show sensor data types within
    //    Show within_city places on map
    //

    // sensor_data: Sensor data type
    // gather data from all nearest sensors ( 15 nearest? ) with that type

    // Within city:
    // Data from specific place within city
    //    List the data types avaliable
    //    Sensor coverage on map
    //    Region on map

  }
}
