
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:ui/pages/ViewCardContent.dart';

import 'BlurHashProvider.dart';

/*enum CardContentOpt{
  TITLE,DESCRIPTION
}
class ExibitCardContentPicker{
  static String? from(CardContentOpt o,CardContentDataType? d,dynamic element){
    switch(d){
      case CardContentDataType.Tags:
        return
          o==CardContentOpt.TITLE?
            "Visita à ${element["tag"]}":
          o==CardContentOpt.DESCRIPTION?"Conferir as condições de ${element["tag"]} da região":
          null;
      case CardContentDataType.SensorData:
        return
          o==CardContentOpt.TITLE?
          "Índices de $element":
          o==CardContentOpt.DESCRIPTION?
            "Consultar índices de $element da proximidade":
              null;
      case CardContentDataType.WithinCity:
        break;
      case CardContentDataType.NearbyCities:
        break;
      default:
        break;
    }
  }
}*/

class ExibitCardLoader{
  static final ExibitCardLoader _instance = ExibitCardLoader._internal();

  factory ExibitCardLoader(){
    return _instance;
  }

  _loadimg(String? dir){
    if(dir==null) return null;
    return Image.network(dir,width: 80,height: 80,color: Colors.white,);
  }

  ExibitCardLoader._internal();

  static final List<_ExibitCard> _list=[];
  //static late List<dynamic> _blur_hash_listing = [];
  void initializer(Map<String,dynamic> cards_data,BuildContext context) {           // cards_data = {sensordata: [CO2], tags: []}
    _list.clear();
    BlurHashProvider bhp = BlurHashProvider();
    cards_data.forEach((key, list)=>
        list.forEach((value)=> _list.add(_ExibitCard(
            parentContext: context,
            title: value["name"],
            icon: _loadimg(value["icon"]),
            db_id: value["_id"],
            description: value["description"],
            blurShadowHash: bhp.pick(), // tag_mongo_replace v2 || cards_data_retrieve.blurhash salvo
            action: () async {
              if(key=="suggestions") return;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext c) {
                    return ViewCardContent(db_id: value["_id"],title: value["name"],description: value["description"],detailed: value["detailed"],);
                  }));
            },
          ))
        )
    );

    //UI_TIPS
    // barely any programs recognized
    // low end-device density
    // change regions / pick on map
    // unnacurate location

    _list.isNotEmpty?_list.last.isLast=true:null;
  }
  /*void initializer(Map<String,dynamic> cards_data,BuildContext context) {           // cards_data = {sensordata: [CO2], tags: []}
    _list.clear();
    BlurHashProvider bhp = BlurHashProvider();
    cards_data.forEach((key, list)=>
        list.forEach((value)=>
            _list.add(ExibitCard(
              parentContext: context,
              title: ExibitCardContentPicker.from(CardContentOpt.TITLE, CardContentDataType.fromString(key), value),
              description: ExibitCardContentPicker.from(CardContentOpt.DESCRIPTION,CardContentDataType.fromString(key), value),
              blurShadowHash: bhp.pick(),
              action: CardContentDataType.fromString(key)!=null?() async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext c) {
                      return ViewCardContent(CardContentDataType.fromString(key)!,value);
                    }));
              }:null,
            )),)
    );

    //UI_TIPS
    // barely any programs recognized
    // low end-device density
    // change regions / pick on map
    // unnacurate location

    _list.isNotEmpty?_list.last.isLast=true:null;
  }*/

  /*
  void legacyInitializer(Map<String,dynamic> cards_data,BuildContext context) {
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
  */

  List<_ExibitCard> get toList => _list;

  _ExibitCard item(int i){return _list[i];}

  int get length => _list.length;
/*int length(){
    return _list.length;
  }*/

}

class _ExibitCard extends StatefulWidget{
  late BuildContext parentContext;

  String? db_id;
  String? title;
  String? description;

  String blurShadowHash;
  Image? icon;
  //Icon? icon;
  bool isLast=false;
  Function? action;

  //ExibitCard.fromJson(Map json):title = json['title'],description = json['description'],blurShadowHash=json['blurShadowHash'],img=json['img'];
  _ExibitCard({Key? key,required this.parentContext,this.db_id,this.title,this.description,required this.blurShadowHash,this.action,this.icon}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ExibitCardState();
}

class _ExibitCardState extends State<_ExibitCard>{

  final defaultFunction = const SnackBar(
    content: Text('Nenhuma função definida'),
    duration: Duration(seconds:4),
  );


  @override
  Widget build(BuildContext context) => Card(
      margin: EdgeInsets.fromLTRB(5,12,5,widget.isLast?84:12),
      elevation: 3,
      shadowColor: Colors.black38,
      color: Theme.of(context).accentColor,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //ScaffoldMessenger.of(context).showSnackBar();
        /*final val = await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext c) {
                return new ViewImage(_imagesController.images[i].id!);
              }));
          if(val != null && val == true) loaded();*/
        child: Flex(
          mainAxisSize: MainAxisSize.max,
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child:Ink(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: BlurHashImage(widget.blurShadowHash),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: widget.icon ?? const Icon(
                          Icons.check,
                          size: 80,
                          color: Colors.white,
                        ),
              ),
            ),),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0,10),
              child: Text(widget.title ?? "Unknown title",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 26,
                    fontFamily: "Verdana",
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(color: Colors.black,blurRadius: 60),
                    ]
                ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,10),
              child:Text(widget.description ?? "Unknown description",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.description!=""?20:0,
                fontFamily: "Verdana",
                color: Colors.white,
                fontWeight: FontWeight.w300,
                leadingDistribution: TextLeadingDistribution.even,
                letterSpacing: 2.8,
                shadows: const [
                  Shadow(color: Colors.black,blurRadius:60),
                ],
              ),),
            ),
          ],
        ),
      ),
    );

  /*Widget legacyBuild(BuildContext context) => Card(
    margin: EdgeInsets.fromLTRB(5,12,5,widget.isLast?84:12),
    elevation: 3,
    shadowColor: Colors.black54,
    borderOnForeground: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
    child: InkWell(
      //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
      onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
      //ScaffoldMessenger.of(context).showSnackBar();
      *//*final val = await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext c) {
                return new ViewImage(_imagesController.images[i].id!);
              }));
          if(val != null && val == true) loaded();*//*

      child: Ink(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.img==null?BlurHashImage(widget.blurShadowHash):widget.img!.image,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
            padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
            *//*decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),*//*
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title ?? "Unknown title",
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
                Text(widget.description ?? "Unknown description",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.description!=""?20:0,
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
        *//*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*//*
      ),
    ),
  );*/
}



