
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';


class ExibitCard extends StatefulWidget{
  late BuildContext parentContext;
  String title;
  String description;
  String blurShadowHash;
  Image? img;
  bool isLast=false;
  Function? action;
  ExibitCard.fromJson(Map json):title = json['title'],description = json['email'],blurShadowHash=json['blurShadowHash'],img=json['img'];
  ExibitCard({Key? key,required this.parentContext,required this.title,required this.description,required this.blurShadowHash,this.action,this.img}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ExibitCardState();
}

class _ExibitCardState extends State<ExibitCard>{

  final defaultFunction = const SnackBar(
    content: Text('Nenhuma função definida'),
    duration: Duration(seconds:4),
  );


  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.fromLTRB(5,12,5,widget.isLast?84:12),
    elevation: 3,
    shadowColor: Colors.black54,
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
            /*decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),*/
            child: Flex(direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title,
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
                Text(widget.description,
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
        /*ClipRect(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 1.3,sigmaY: 1.3),child: Container()),),*/
      ),
    ),
  );
}



