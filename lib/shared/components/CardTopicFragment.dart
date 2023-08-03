//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:ui/pages/components/BarChartDataSample.dart';
import 'package:ui/pages/components/LineChartDataByOffset.dart';
import 'package:ui/pages/components/PieChartDataSample.dart';


import 'package:latlong2/latlong.dart';

import '../../pages/paging_fragments/map.dart';
import '../control/LocationHandler.dart';
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
  final String? title, detailed, description;
  final String? dataset_interval;
  final List<dynamic>? dataset_data_type;
  final String? data_display;
  final List<dynamic>? data_parsing_functions;
  final Map<String,dynamic> static_input_data;
  final dynamic data;

  Function? stateful_viewcardcontent_passthrough;

  CardTopicFragment({Key? key,this.stateful_viewcardcontent_passthrough,required String this.title, required String this.detailed, required String this.description, required this.dataset_interval,required this.static_input_data,required this.dataset_data_type,required this.data_parsing_functions,required this.data_display,this.data}) : super(key: key);

  void _fetchAction(String note,BuildContext context) async {
    switch(note){
      case "map_pick":

        //https://stackoverflow.com/questions/49824461/how-to-pass-data-from-child-widget-to-its-parent

          LatLng? result = await Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => MapFragment(mode: MapFragmentMode.LOCATIONPICKER,),
            fullscreenDialog: true,)
          );

          if(result!=null)
            stateful_viewcardcontent_passthrough!=null?
              stateful_viewcardcontent_passthrough?.call(()=>{
                LocationHandler.manually_set = true,
                LocationHandler.locationAvaliable=true,
                LocationHandler.defineLocationManually(LocationData.fromMap({"latitude":result.latitude,"longitude":result.longitude}))
              }):null;

          //Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result"),duration: const Duration(seconds: 3),));
          break;
      default:
        print("tapped :D");
    }
  }

  Widget _fetchBuild(BuildContext context){
    switch(data_display){
      case "wide_card_button": return _ui_wide_card_button(context);
      case "radial": return _radial_card(context);
      case "histogram": return _realtime_index(context);
      /*case CardTopicType.SENSORDATACLOUD: return _sensorDataCloudCard();
      case CardTopicType.realtime_index:return _realtime_index();
      case CardTopicType.last24h_graph: return _last24h_graph();
      case CardTopicType.comparison_yearly_monthly: return _comparison_yearly_monthly();
      case CardTopicType.averages_daterange:return _averages_daterange();
      case CardTopicType.averages_by_something:return _averages_by_something();*/
      default: return _unknownCard();
    }
  }



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

  List<List<double>> _make_hist_chart_data(){
    List<List<double>> retr=[];
    //DateTime now = DateTime.now();
    DateTime now = DateTime.parse("2023-05-07T16:50:00.000+00:00");

    //bool relative = dataset_interval?.contains("relative")??true;

    data[0].forEach((dataObj)=>retr.add(
        [
          DateTime.parse(dataObj["date"].toString()).difference(now).inSeconds.toDouble(),
          double.parse(dataObj["data"])
        ]
    ));

    /*
      reversed?data[0].forEach((dataObj)=>retr.add(
          [
            DateTime.parse(dataObj["date"].toString()).difference(now).inSeconds.toDouble(),
            double.parse(dataObj["data"])
          ]
      )):
      data[0].forEach((dataObj)=>retr.add(
          [
            now.difference(
                DateTime.parse(dataObj["date"].toString())
            ).inSeconds.toDouble(),
            double.parse(dataObj["data"])
          ]
      ));
    * */
    return retr;
  }

  Widget _realtime_index(BuildContext context) {
    DateTime now = DateTime.parse("2023-05-07T16:50:00.000+00:00");
    List<ChartedGraphData<DateTime,double>> dataList = [];
    List<ChartedGraphData<DateTime,double>> meanList = [];

    data[0].forEach((x)=>dataList.add(ChartedGraphData(
        now.subtract(now.difference(DateTime.parse(x["date"].toString()))),
        double.parse(x["data"]))
    ));

    for(int i=0;i < dataList.length-3;i+=3) {
      meanList.add(ChartedGraphData(dataList[i+1].x, (dataList[i].y +dataList[i+1].y+dataList[i+2].y)/3.0));
    }

    return Column(
       mainAxisSize: MainAxisSize.min,
         children:[
           const Padding(
              padding: EdgeInsets.all(5),
              child: Text("Últimas 24 horas",style: TextStyle(
                fontSize: 28
              ),),
          ),
           SizedBox(
             height: 270,
             child: SfCartesianChart(

                 primaryXAxis: DateTimeCategoryAxis(
                   majorGridLines: MajorGridLines(width: 0),
                   minorGridLines: MinorGridLines(width: 0),
                   interval: 2,
                   rangePadding: ChartRangePadding.none,
                   labelStyle: TextStyle(
                     wordSpacing: 1,
                     fontSize: 13,
                   ),
                   labelIntersectAction: AxisLabelIntersectAction.rotate45,
                   labelPlacement: LabelPlacement.onTicks,
                   maximumLabels: 12,
                   intervalType: DateTimeIntervalType.auto,
                 ),
                 primaryYAxis: NumericAxis(
                   rangePadding: ChartRangePadding.additional,

                   //majorGridLines: MajorGridLines(width: 0),
                   minorGridLines: MinorGridLines(width: 0),
                 ),

                 enableAxisAnimation: true,
                 // Chart title
                 //title: ChartTitle(text: 'Half yearly sales analysis'),
                 // Enable legend
                 legend: Legend(isVisible: false,),
                 plotAreaBorderColor: Colors.transparent,
                 plotAreaBackgroundColor: Colors.transparent,
                 backgroundColor: Colors.transparent,
                 borderColor: Colors.transparent,

                 // Enable tooltip
                 //onTooltipRender: (TooltipArgs args) => args.locationX -= 30,
                 tooltipBehavior: TooltipBehavior(enable: true),

                 series: <CartesianSeries<ChartedGraphData<DateTime,double>, DateTime>>[
                   SplineSeries<ChartedGraphData<DateTime,double>, DateTime>(
                     dataSource: dataList,
                     xValueMapper: (ChartedGraphData<DateTime,double> dat, _) => dat.x,
                     yValueMapper: (ChartedGraphData<DateTime,double> dat, _) => dat.y,
                     cardinalSplineTension: 0.2,
                     markerSettings: const MarkerSettings(
                       shape: DataMarkerType.diamond,
                       isVisible: true,
                       borderWidth: 3,
                       width: 7,
                       height: 7,
                       borderColor: Colors.greenAccent,
                     ),
                     // Enable data label
                     color: Colors.greenAccent,
                     width: 5.5,
                     opacity: 0.6,
                     //dataLabelSettings: DataLabelSettings(isVisible: true),
                     name: "CO²",
                   ),LineSeries<ChartedGraphData<DateTime,double>, DateTime>(
                     dataSource: meanList,
                     xValueMapper: (ChartedGraphData<DateTime,double> dat, _) => dat.x,
                     yValueMapper: (ChartedGraphData<DateTime,double> dat, _) => dat.y,
                     color: Colors.blue,
                     width: 3.5,
                     markerSettings: MarkerSettings(isVisible: false,),
                     enableTooltip: false,
                     //dataLabelSettings: DataLabelSettings(isVisible: true),
                   )
                 ]
             ),
           ),
           /*Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: const [
               Text("< Mais antigo",style: TextStyle(fontSize: 20),),
               Text("Mais recente >",style: TextStyle(fontSize: 20))
             ],
           )*/
           /*Expanded(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               //Initialize the spark charts widget
               child: SfSparkLineChart.custom(
                 //Enable the trackball
                 trackball: SparkChartTrackball(
                     activationMode: SparkChartActivationMode.tap),
                 //Enable marker
                 marker: SparkChartMarker(
                     displayMode: SparkChartMarkerDisplayMode.all),
                 //Enable data label
                 labelDisplayMode: SparkChartLabelDisplayMode.all,
                 xValueMapper: (int index) => meanList[index].x,
                 yValueMapper: (int index) => meanList[index].y,
                 dataCount: meanList.length,
               ),
             ),
           )*/
          //LineChartDataByOffset(data_list: _make_hist_chart_data(),title: "",reversed: true, isRelative: dataset_interval?.contains("relative")??true,)
        ]
    );
  }
  Widget _last24h_graph()=>Container(
    child: Column(
        children:[
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("Nas últimas 24 horas.",style: TextStyle(
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
                      child: Text("Densidade de {type!} dentro do nível adequado.")
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
                  Text("Unknown data received, try updating the app",
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

  Widget _ui_wide_card_button(BuildContext context){
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 3,
      shadowColor: Colors.black54,
      borderOnForeground: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      child: InkWell(
        //onTap:() => widget.action?.call() ?? {ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        //onTap: widget.action!=null?(){widget.action?.call();} : ()=>{ScaffoldMessenger.of(context).showSnackBar(defaultFunction)},
        onTap: ()=>_fetchAction(static_input_data["action"],context),
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
                  Text(static_input_data["title"],
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
                  Text(static_input_data["desc"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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


  Widget _radial_card(BuildContext context)=>Column(
      children:[
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(static_input_data["title"]??"no title provided",style: const TextStyle(
              fontSize: 28
          ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,20),
                    child: Text(static_input_data["desc"]??"no description provided")
                ),
              ),
            ),
            PieChartSample2(max: data[0][2] +.0,min: data[0][0] +.0,radius_gap_percentage: 0.2,text_type: "${((data[0][1]??100)+.0).toInt()} %", val: (data[0][1]??100)+.0,),
          ],
        )
      ]
  );

  @override
  Widget build(BuildContext context)=>Padding(
    padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
    child: _fetchBuild(context),
  );
}

class ChartedGraphData<T,W> {
  ChartedGraphData(this.x, this.y);
  final T x;
  final W y;

  static List<ChartedGraphData<A,B>> build<A,B>(Map<A,B> data){
      List<ChartedGraphData<A,B>> ls = [];
      data.forEach((key, value) => ls.add(ChartedGraphData(key, value)));
      return ls;
  }
}