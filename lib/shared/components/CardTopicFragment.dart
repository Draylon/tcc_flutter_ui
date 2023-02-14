import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:ui/pages/components/BarChartDataSample.dart';
import 'package:ui/pages/components/LineChartDataByOffset.dart';
import 'package:ui/pages/components/PieChartDataSample.dart';

import 'BlurHashProvider.dart';

enum CardTopicType{
  LOCATIONS,LOCATIONMETRICS,SENSORDATACLOUD,
  realtime_index,last24h_graph,comparison_yearly_monthly,averages_daterange,averages_by_something;

@override
String toString(){
  return name;
}
String toLower() => toString().toLowerCase();
static CardTopicType? fromString(String s){for (CardTopicType element in CardTopicType.values) {if(element.toLower()==s.toLowerCase())return element;}return null;}
}

class GraphData {
  GraphData(this.x, this.y);
  final int x;
  final double y;
}

class CardTopicFragment extends StatelessWidget{

  final CardTopicType? type;
  final dynamic data;
  const CardTopicFragment({Key? key,required this.type,this.data}) : super(key: key);

  Widget _fetchBuild(){
    switch(type){
      case CardTopicType.LOCATIONS: return _locationCard();
      case CardTopicType.LOCATIONMETRICS:return _locationMetricsCard();
      case CardTopicType.SENSORDATACLOUD: return _sensorDataCloudCard();
      case CardTopicType.realtime_index:return _realtime_index();
      case CardTopicType.last24h_graph: return _last24h_graph();
      case CardTopicType.comparison_yearly_monthly: return _comparison_yearly_monthly();
      case CardTopicType.averages_daterange:return _averages_daterange();
      case CardTopicType.averages_by_something:return _averages_by_something();
      default: return _unknownCard();
    }
  }

  @override
  Widget build(BuildContext context)=>Padding(
    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
    child: _fetchBuild(),
  );

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
      margin: const EdgeInsets.all(5),
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

  List<List<double>> _makeData1(bool reversed){
    List<List<double>> retr=[];
    DateTime now = DateTime.parse("2023-02-11T13:02:56.000+00:00");//.now();
    reversed?data["sensor_data"].forEach((data_obj)=>retr.add(
        [
          DateTime.parse(data_obj["date"].toString()).difference(now).inSeconds.toDouble(),
          double.parse(data_obj["data"])
        ]
    )):
    data["sensor_data"].forEach((data_obj)=>retr.add(
        [
          now.difference(
              DateTime.parse(data_obj["date"].toString())
          ).inSeconds.toDouble(),
          double.parse(data_obj["data"])
        ]
    ));
    return retr;
  }

  Widget _realtime_index()=>Container(
     child: Column(
         children:[
           Padding(
              padding: EdgeInsets.all(5),
              child: Text("Últimas aferições",style: TextStyle(
                fontSize: 28
              ),),
          ),
          LineChartDataByOffset(data_list: _makeData1(true),title: "",reversed: true)
        ]
    ),
  );
  Widget _last24h_graph()=>Container(
    child: Column(
        children:[
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("Qualidade nas últimas 24 horas.",style: TextStyle(
              fontSize: 28
            ),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0,20,0,20),
                      child: Text("Densidade de ${type!} dentro do nível adequado.")
                  ),
                ),
              ),
              PieChartSample2(max: 500,min: 0,radius_gap_percentage: 0.2,text_type: "CO2", val: 421,),
            ],
          )
        ]
    ),
  );
  Widget _comparison_yearly_monthly()=>Container(
    child: Text("Weekly and monthly comparison"),
  );
  Widget _averages_daterange()=>Container(

  );
  Widget _averages_by_something()=>Container();

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