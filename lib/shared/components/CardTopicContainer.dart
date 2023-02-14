
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import 'package:location/location.dart';
import '../control/LocationHandler.dart';
import 'BlurHashProvider.dart';
import 'CardTopicFragment.dart';



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
    print(topic_data);
    _list.clear();
    topic_data.forEach((value) {
      Map<String,dynamic> block = value ?? {"type":"","data":[]};
      block["data"].forEach((block_u)=> _list.add(CardTopicFragment(type: CardTopicType.fromString(block["type"]),data:block_u)));
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