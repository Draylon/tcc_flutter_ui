
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:location/location.dart';
import '../control/LocationHandler.dart';
import 'BlurHashProvider.dart';

enum CardTopicType{
  LOCATIONS,LOCATIONMETRICS,SENSORDATACLOUD
}

class CardTopicFragment extends StatelessWidget{

  final CardTopicType type;
  final dynamic data;
  const CardTopicFragment({Key? key,required this.type,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      this.type==CardTopicType.LOCATIONS?_locationCard():
      this.type==CardTopicType.LOCATIONMETRICS?_locationMetricsCard():
      this.type==CardTopicType.SENSORDATACLOUD?_sensorDataCloudCard():
      _unknownCard();

  _paddingListBuilder(List<Widget> listing){
    List<Widget> retr = [];
    listing.forEach((e)=>retr.add(
      Padding(
        padding: const EdgeInsets.all(15),
        child: e,
      )
    ));
    return retr;
  }


  Widget _locationCard(){
    print(data);
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: ()=>{print("tapped :D")},
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: BlurHashImage(BlurHashProvider.randPick()),
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
              /*decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),*/
              child: Flex(direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _paddingListBuilder([
                  Text(data["name"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: "Verdana",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black,blurRadius: 60),
                        ]
                    ),),
                  Text(data["description"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: data["description"]!=""?20:0,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                  Text("Dispositivos:${data["devices"].length} registrados no local",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: data["description"]!=""?20:0,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                  Text("Acomodações do local:${data["location_type"].length} tipos diferentes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: data["description"]!=""?20:0,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                  Text("Distância do local atual:${data["distance"]} metros",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: data["description"]!=""?20:0,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                ]),

              )
          ),
          /*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*/
        ),
      ),
    );
  }
  Widget _locationMetricsCard(){
    print(data);
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: ()=>{print("tapped :D")},
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: BlurHashImage(BlurHashProvider.randPick()),
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
              /*decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),*/
              child: Flex(direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Text(data,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: "Verdana",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black,blurRadius: 60),
                        ]
                    ),),*/
                  Text(data,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      //fontSize: data["description"]!=""?20:0,
                      fontSize: 20,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                ],

              )
          ),
          /*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*/
        ),
      ),
    );
  }
  Widget _sensorDataCloudCard(){
    print(data);
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: ()=>{print("tapped :D")},
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: BlurHashImage(BlurHashProvider.randPick()),
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
              /*decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),*/
              child: Flex(direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Text(data,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: "Verdana",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black,blurRadius: 60),
                        ]
                    ),),*/
                  Text(data,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      //fontSize: data["description"]!=""?20:0,
                      fontSize: 20,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: const [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                ],

              )
          ),
          /*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*/
        ),
      ),
    );
  }

  Widget _unknownCard(){
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: ()=>{print("tapped :D")},
        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: BlurHashImage(BlurHashProvider.randPick()),
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
              /*decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),*/
              child: Flex(direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Card Parsing Error",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: "Verdana",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black,blurRadius: 60),
                        ]
                    ),),
                  Text("Unknown data sent, update app",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Verdana",
                      fontWeight: FontWeight.w300,
                      leadingDistribution: TextLeadingDistribution.even,
                      letterSpacing: 2.8,
                      shadows: [
                        Shadow(color: Colors.black,blurRadius:60),
                      ],
                    ),),
                ],

              )
          ),
          /*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*/
        ),
      ),
    );
  }

}


class CardTopicContainer{
  static final CardTopicContainer _instance = CardTopicContainer._internal();

  factory CardTopicContainer(){
    return _instance;
  }

  bool _locationAvaliable=false;
  LocationData? _curr_location;
  _fetch_latitude_longitude(/*{bool precision=false}*/) async {

    // check permission
    print("check permission");

    await LocationHandler.checkGPSPermission().then((value) {
        _locationAvaliable = value == PermissionStatus.granted;
    }, onError: (e) {
      print("Error on GPS permission");
      print(e);
    });

    //retrieve coordinates
    //LocationData? curr_location;
    if(_locationAvaliable){
      print("retrieve coordinates");
      await LocationHandler.requestCurrentGPS(prompt: false).then((value) {
        _curr_location=value;
      },onError: (e){
        _locationAvaliable=false;
        print("Error on GPS Location retrieval");print(e);
      });

      _curr_location==null?_locationAvaliable=false:null;

    }else{
      Map<String,dynamic> whois_json;
      String whois_params ='latitude,longitude';

      await LocationHandler.cached_isp_data(whois_params).then((whois_response) {
        whois_json = whois_response;
        return true;
      }, onError: (e) {
        print("Error on whois fetch:");
        print(e);
        //setState((){failureMessage="Error on whois fetch";menuLoaded=1;});
        //return false;
      });
    }
  }

  CardTopicContainer._internal();

  static final List<CardTopicFragment> _list=[];
  //static late List<dynamic> _blur_hash_listing = [];
  void initializer(List<dynamic> topic_data,BuildContext context) {
    _list.clear();
    topic_data.forEach((value) {
      Map<String,dynamic> block = value;
      switch(block["type"]){
        case "locations":
          // showcase locations cards
          block["data"].forEach((block_u)=> _list.add(CardTopicFragment(type: CardTopicType.LOCATIONS,data:block_u)));
          break;
        case "locationmetrics":
          block["data"].forEach((block_u)=> _list.add(CardTopicFragment(type: CardTopicType.LOCATIONMETRICS,data:block_u)));
          break;
        case "sensordatacloud":
          block["data"].forEach((block_u)=> _list.add(CardTopicFragment(type: CardTopicType.SENSORDATACLOUD,data:block_u)));
          break;
      }

    });
  }
  /*void initializer2(Map<String,dynamic> topic_data,BuildContext context){
    _list.clear();

    _fetch_location_data();

    List<dynamic> tags = topic_data["tags"];
    List<dynamic> tags_en = topic_data["tags_en"];
    List<dynamic> sensor_data = topic_data["sensor_data"];
    List<dynamic> within_city = topic_data["within_city"];
    List<dynamic> nearby_cities = topic_data["nearby_cities"];

    tags.shuffle();
    sensor_data.shuffle();
    within_city.shuffle();
    nearby_cities.shuffle();
    //tags.length>3?tags.removeRange(3,tags.length):null;
    sensor_data.length>3?sensor_data.removeRange(3,sensor_data.length):null;
    within_city.length>3?within_city.removeRange(3,within_city.length):null;
    nearby_cities.length>3?nearby_cities.removeRange(3,nearby_cities.length):null;

    //request api for blurhashes
    //request some images based on tags,


    BlurHashProvider bhp = BlurHashProvider();

    const Image loaded = Image(image: AssetImage("assets/logo3.png"));
    tags.forEach((element)=>{
      _list.add(CardTopicFragment(parentContext: context,title: "Visita à $element", description: "Conferir as condições de $element da região",blurShadowHash: bhp.pick(),action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.Tags,element);
            }));
      },)),

    });
    sensor_data.forEach((element)=>{
      _list.add(ExibitCard(parentContext: context,title: "Índices de $element", description: "Consultar índices de $element da proximidade", blurShadowHash: bhp.pick(),action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.SensorData,element);
            }));
      },))
    });
    within_city.forEach((element)=>{
      _list.add(ExibitCard(parentContext: context,title: "$element", description: "Sobre $element na cidade", blurShadowHash: bhp.pick(),action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.WithinCity,element);
            }));
      },))
    });
    nearby_cities.forEach((element)=>{
      _list.add(ExibitCard(parentContext: context,title: "Viajar à $element", description: "Informações sobre a cidade vizinha de $element", blurShadowHash: bhp.pick(),action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.NearbyCities,element);
            }));
      },))
    });

    _list.shuffle();

    int append_defaults = 1;// 2° elemento
    List<ExibitCard> default_topics = [
      ExibitCard(parentContext: context,title: "Mapa Regional", description:"Mapa interativo da região",blurShadowHash: bhp.pick(),
        img: const Image(image: AssetImage("assets/logo2.png"),),
        action: () async => {
          await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext c) {
                return PageMap(title: "Mapa apartir de card");
              })),
        },),
      ExibitCard(parentContext: context,title: "Busque um local", description:"",blurShadowHash: bhp.pick(), img: const Image(image: AssetImage("assets/logo1.png"),),
          action: () async => {
            await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return SearchPage();
                }))
          }),
    ];
    default_topics.forEach((element) {
      if(_list.length>append_defaults){
        _list.insert(append_defaults, element);
      }else{
        _list.add(element);
      }
      append_defaults+=2;
    });
    _list.isNotEmpty?_list.last.isLast=true:null;
  }*/

  List<CardTopicFragment> toList(){return _list;}

  CardTopicFragment item(int i){return _list[i];}

  int length(){
    return _list.length;
  }
}