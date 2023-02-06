

import 'package:flutter/material.dart';
import 'package:ui/pages/SearchPage.dart';
import 'package:ui/pages/map_paging.dart';

import 'exibit_card.dart';
import '../../pages/ViewCardContent.dart';
import 'BlurHashProvider.dart';

class ExibitCardLoader{
  static final ExibitCardLoader _instance = ExibitCardLoader._internal();

  factory ExibitCardLoader(){
    return _instance;
  }

  ExibitCardLoader._internal();

  static final List<ExibitCard> _list=[];
  //static late List<dynamic> _blur_hash_listing = [];
  void initializer(Map<String,dynamic> cards_data,BuildContext context) {
    _list.clear();
    List<dynamic> tags = cards_data["tags"];
    List<dynamic> tags_en = cards_data["tags_en"];
    List<dynamic> sensor_data = cards_data["sensor_data"];
    List<dynamic> within_city = cards_data["within_city"];
    List<dynamic> nearby_cities = cards_data["nearby_cities"];

    Map<dynamic,dynamic> tags_merge={};
    for(int x=0;x<tags.length;x++) tags_merge[tags[x]] = tags_en[x];

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
      _list.add(ExibitCard(parentContext: context,title: "Visita à $element", description: "Conferir as condições de $element da região",blurShadowHash: bhp.pick(),action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent.split(CardContentDataType.Tags,element,tags_merge[element]);
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
  }

  List<ExibitCard> toList(){return _list;}

  ExibitCard item(int i){return _list[i];}

  int length(){
    return _list.length;
  }

}