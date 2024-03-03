

import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/api/call.dart';
import 'package:ui/pages/HelpPage.dart';
import 'package:ui/pages/SearchPage.dart';
import 'package:ui/pages/addNewDevice.dart';
import 'package:ui/pages/map_paging.dart';
import 'package:ui/pages/paging_fragments/map.dart';
import 'package:ui/shared/components/exibit_card.dart';
import 'package:ui/pages/SettingsPage.dart';
import 'package:ui/shared/components/LoadingIndicator.dart';
import 'package:ui/shared/control/LocationHandler.dart';
import 'package:location/location.dart';

import '../shared/components/LoadingFailed.dart';
import 'package:latlong2/latlong.dart';

import 'components/PickBluetoothDevice.dart';

class CardPage extends StatefulWidget {
  CardPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) => _buildPage();

  @override
  void initState() {
    super.initState();
    return;

    //Set intro to done/true
    SharedPreferences.getInstance().then((prefs) => {
      prefs.setBool('intro_screen',true)
    });

    LocationHandler.locationDataNotifier.addListener(() {
      fetchFirst?_fetch_card_data(refresh: true):null;
    });
    _fetch_card_data();
    //AppDatabase().openDb().whenComplete(loaded);
  }

  @override
  void dispose(){
    super.dispose();
  }

  
  //bool locationAvaliable=false;
  //bool LocationHandler.manually_set = false;



  bool fetchFirst=false;
  _fetch_card_data({bool refresh=false}) async{
    print('fetching card data?');
    if(refresh){
      setState(() {
        LocationHandler.geocode_json.clear();
      });

      await LocationHandler.geocode_update(this);
    } else if(!LocationHandler.locationAvaliable) await LocationHandler.fetch_location_data(this);

    Map<String,dynamic> azureJson={};
    if(LocationHandler.whois_json.isEmpty && !LocationHandler.locationAvaliable){
      setState((){failureMessage="Problema no apontamento da região";menuLoaded=1;});
      return;
    }
    print("location data obtained");
    print("Obtendo cards");
    Map<String,dynamic>? apiRequestsQuery;
    if(LocationHandler.locationAvaliable){
      print("Precise locations avaliable");
      apiRequestsQuery={
        'ip': LocationHandler.whois_json['ip'],
        'country': LocationHandler.geocode_json['country'],
        'city': LocationHandler.geocode_json['county'],
        'street_name': LocationHandler.geocode_json['name'],
        'region': LocationHandler.geocode_json['region'],
        'latitude': LocationHandler.locationData?.latitude.toString(),
        'longitude': LocationHandler.locationData?.longitude.toString(),
      };

    }else{
      print("Location unavaliable, Sticking to whois");
      apiRequestsQuery={
        'ip': LocationHandler.whois_json['ip'],
        'country': LocationHandler.whois_json['country'],
        'city': LocationHandler.whois_json['city'],
        'latitude': LocationHandler.whois_json['latitude'].toString(),
        'longitude': LocationHandler.whois_json['longitude'].toString(),
      };

    }

    await ApiRequests.get("/api/v2/ui_data/main_menu",apiRequestsQuery).then((apiResponse) {
      print("Request completed");
      if (apiResponse.statusCode == 200) {
        try{
          azureJson = json.decode(apiResponse.body);
          print(azureJson);
          avaliableCards.initializer(azureJson,context);

          setState(() {
            menuLoaded=2;
            //azure_json.map((e) => ExibitCard.fromJson(e)).toList();
          });
        }on Exception catch(e){
          print(e);
          setState((){failureMessage="API returned invalid data";menuLoaded=1;});
        }
      }else{
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

  int menuLoaded=0;
  String failureMessage="Loading Failed!\nPlease refresh";
  ExibitCardLoader avaliableCards = ExibitCardLoader();
  //List<ExibitCard>avaliableCardsContainer = [];

  //()=>ScaffoldMessenger.of(context).showSnackBar(markerClicked),
  final settingsMarker = const SnackBar(
    content: Text('Settings em breve'),
    duration: Duration(seconds:3),
  );
  final buscaMarker = const SnackBar(
    content: Text('S/ Busca por enquanto\nProblema no mongo'),
    duration: Duration(seconds:4),
  );

  String _getTime(){
    DateTime now = DateTime.now();
    if(now.hour < 12) return "Bom dia.";
    if(now.hour < 18) return "Boa tarde.";
    return "Boa noite.";
  }

  _buildPage(){
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx,isScrolled)=>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Container(
              padding: const EdgeInsets.fromLTRB(15, 0,15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text("SmartJoinville",style: TextStyle(
                      fontSize: 26,
                    ),),
                  ),
                  FittedBox(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(15)),
                        foregroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColorDark),
                        //side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1,color: Theme.of(context).primaryColorDark)),
                      ),
                      onPressed: () async => {
                        LocationHandler.checkGPSPermission().then((value) async => {
                          value==PermissionStatus.granted
                          ? await LocationHandler.manual_location_data(ctx,this)
                          : await LocationHandler.fetch_location_data(this,precision: true)
                        })
                      },
                      onLongPress:  () async {
                          await LocationHandler.manual_location_data(ctx,this);
                          _fetch_card_data();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            child: LocationHandler.locationAvaliable?LocationHandler.manually_set?const Icon(Icons.location_pin):const Icon(Icons.near_me):const Icon(Icons.wifi_tethering),
                          ),
                          Text(LocationHandler.uiCityName,style: const TextStyle(
                              fontSize: 20
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.blueGrey,
          )
        ],
        body: RefreshIndicator(
        displacement: 80,
        onRefresh:(){return _fetch_card_data();},
        child:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,0,30,0),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(_getTime(),style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        wordSpacing: 3,
                      ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,15,0,0),
                    child: Text(
                      menuLoaded==0?
                      "Obtendo serviços disponíveis":
                      menuLoaded==1?"Serviços indisponíveis, tente novamente":"Consulte dentre os itens disponíveis abaixo",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200
                      ),
                    ),
                  ),
                ],
              ),
            ),
            menuLoaded==0?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox.square(
                    dimension: 150,
                    child: LoadingIndicator(),
                  )
                ],
              )
            :menuLoaded==1?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: ()=>_fetch_card_data(refresh: true), child:
                    SizedBox.square(
                      dimension: 150,
                      child: LoadingFailed(message: failureMessage,),
                    )
                  )
                ],
              ):
            AlignedGridView.count(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avaliableCards.length,
                itemBuilder: (ctx,i)=>avaliableCards.item(i)
            ),
          ],
        ),
        ),
      ),

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:FloatingActionButton(
        //onPressed: ()=>ScaffoldMessenger.of(context).showSnackBar(settingsMarker), // liberar logo settings <=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=<=
        /*onPressed: () async => {
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => SearchPage()))
        },*/
        onPressed: () async => {
          // interactive map page
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => PageMap(title: "Mapa interativo")))
        },
        child: const Icon(Icons.map_outlined),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // não sei oq por aqui kkkk
                      IconButton(onPressed: () async =>{
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext c) {
                              return HelpPage();
                            }))
                      }, icon: const Icon(Icons.help_outline,),),IconButton(onPressed: () async =>{
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext c) {
                              return SettingsPage();
                            }))
                      }, icon: const Icon(Icons.settings,),),
                      IconButton(onPressed: () async =>{
                          // add device to network?
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext c) {
                              return AddNewDevice();
                            })),
                      }, icon: const Icon(Icons.add,),),
                      /*IconButton(onPressed: () async => {
                          // interactive map page
                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext c) => PageMap(title: "Mapa interativo")))
                      }, icon: const Icon(Icons.map_outlined,),),*/
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );

  }



  _buildPageCards(int i){
    //DateTime d = DateTime.parse(_imagesController.images[i].data!);
    return Container(
      margin: EdgeInsets.fromLTRB(0,5, 0, 5),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black54,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
        child: InkWell(
          onTap: () async {
            /*final val = await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return new ViewImage(_imagesController.images[i].id!);
                }));
            if(val != null && val == true) loaded();*/
          },
          child: Ink(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text("text 1"),
                      Text("text 2"),
                      Text("text 3"),
                      Text("text 4"),
                      /*Text(_imagesController.images[i].titulo!),
                      Text("${d.day}/${d.month}/${d.year} ${d.hour > 12 ? d.hour - 12 : d.hour} : ${d.minute} ${d.hour > 12 ? 'PM' : 'AM'}"),
                      Text(_imagesController.images[i].lat!.toString()),
                      Text(_imagesController.images[i].long!.toString())*/
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text("Image here"),//Image.memory(base64.decode(_imagesController.images[i].img!)),
                    //Image(image: NetworkImage("https://i.pinimg.com/originals/41/71/b1/4171b1b35e0c25ed4871c1109372ea4c.gif"),),
                    margin: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }


}