
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui/pages/paging.dart';

import '../../pages/ViewCardContent.dart';

class ExibitCard extends StatefulWidget{
  late BuildContext parentContext;
  String title;
  String description;
  Image img;
  bool isLast=false;
  Function? action;
  ExibitCard.fromJson(Map json):title = json['title'],description = json['email'],img=json['img'];
  ExibitCard({Key? key,required this.parentContext,required this.title,required this.description,required this.img,this.action}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ExibitCardState();
}

class _ExibitCardState extends State<ExibitCard>{

  final defaultFunction = const SnackBar(
    content: Text('Nenhuma função definida'),
    duration: Duration(seconds:4),
  );


  @override
  Widget build(BuildContext context) => Container(
    //margin: EdgeInsets.fromLTRB(0,10, 0,10),
    child: Card(
      margin: EdgeInsets.fromLTRB(5,12,5,widget.isLast?84:12),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        onTap: ()=>widget.action ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
          //ScaffoldMessenger.of(context).showSnackBar();
          /*final val = await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return new ViewImage(_imagesController.images[i].id!);
                }));
            if(val != null && val == true) loaded();*/

        child: Ink(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: this.widget.img.image,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.3,sigmaY: 0.3),
            child: Container(
                padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
                /*decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(this.widget.title,style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: "Verdana",
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),),
                        Text(this.widget.description,style: TextStyle(
                          color: Colors.white,
                          fontSize: this.widget.description!=""?16:0,
                          fontFamily: "Verdana",
                          fontWeight: FontWeight.w200,
                          letterSpacing: 1.2,
                          overflow: TextOverflow.visible,
                        ),),
                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    ),
  );
}

class ExibitCards{
  static final ExibitCards _instance = ExibitCards._internal();

  factory ExibitCards(){
    return _instance;
  }

  ExibitCards._internal();

  static final List<ExibitCard> _list=[];
  void initializer(Map<String,dynamic> cards_data,BuildContext context){
    _list.clear();
    print(cards_data);
    List<dynamic> tags = cards_data["tags"];
    List<dynamic> sensor_data = cards_data["sensor_data"];
    List<dynamic> within_city = cards_data["within_city"];
    List<dynamic> nearby_cities = cards_data["nearby_cities"];
    tags.shuffle();
    sensor_data.shuffle();
    within_city.shuffle();
    nearby_cities.shuffle();
    tags.length>3?tags.removeRange(3,tags.length):null;
    sensor_data.length>3?sensor_data.removeRange(3,sensor_data.length):null;
    within_city.length>3?within_city.removeRange(3,within_city.length):null;
    nearby_cities.length>3?nearby_cities.removeRange(3,nearby_cities.length):null;

    Image loaded = Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIx5jou3We5US_EAXkxo1tIN-9AJGpeo_X9Q&usqp=CAU");
    tags.forEach((element) {
      _list.add(ExibitCard(parentContext: context,title: "Visita à $element", description: "Conferir as condições de $element da região", img: loaded,action: () async {
        await Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext c) {
                  return ViewCardContent(CardContentDataType.Tags,tags);
                }));
      },));
    });
    sensor_data.forEach((element) {
      _list.add(ExibitCard(parentContext: context,title: "Índices de $element", description: "Consultar índices de $element da proximidade", img: loaded,action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.SensorData,sensor_data);
            }));
      },));
    });
    within_city.forEach((element) {
      _list.add(ExibitCard(parentContext: context,title: "$element", description: "Sobre $element na cidade", img: loaded,action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.WithinCity,within_city);
            }));
      },));
    });
    nearby_cities.forEach((element) {
      _list.add(ExibitCard(parentContext: context,title: "Viajar à $element", description: "Informações sobre a cidade vizinha de $element", img: loaded,action: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return ViewCardContent(CardContentDataType.NearbyCities,nearby_cities);
            }));
      },));
    });

    _list.shuffle();

    int append_defaults = 1;// 2° elemento
    List<ExibitCard> default_topics = [
      ExibitCard(parentContext: context,title: "Mapa Regional", description:"Mapa interativo da região", img: Image(image: AssetImage("assets/logo2.png"),),action: () async {

        await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext c) {
              return PageMap(title: "Page Title");
            }));
      },),
      ExibitCard(parentContext: context,title: "Busque um local", description:"", img: Image(image: AssetImage("assets/logo1.png"),),),
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

  int length(){
    return _list.length;
  }

}