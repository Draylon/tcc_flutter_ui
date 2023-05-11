import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChartDataByOffset_LineChart1 extends StatelessWidget {
  final List<List<double>> data_list;
  final bool reversed;
  final bool isRelative;
  const _LineChartDataByOffset_LineChart1({required this.isShowingMainData,required this.data_list,required this.reversed,required this.isRelative});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  double get _xdmin => data_list.fold(-1, (previousValue, element) {
    if(previousValue>element[0]||previousValue==-1) previousValue=element[0];
    return previousValue;
  });
  double get _xdmax => data_list.fold(-1, (previousValue, element) {
  if(previousValue<element[0]||previousValue==-1) previousValue=element[0];
      return previousValue;
  });
  double get _ydmin => data_list.fold(-1, (previousValue, element) {
    if(previousValue>element[1]||previousValue==-1) previousValue=element[1];
    return previousValue;
  });
  double get _ydmax => data_list.fold(-1, (previousValue, element) {
    if(previousValue<element[1]||previousValue==-1) previousValue=element[1];
    return previousValue;
  });

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: _xdmin,
    maxX: _xdmax,
    maxY: _ydmax+50,
    minY: _ydmin-50,
  );

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: _xdmin,
    maxX: _xdmax,
    maxY: _ydmax+50,
    minY: _ydmin-50,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    /*lineChartBarData1_2,
    lineChartBarData1_3,*/
  ];

  LineTouchData get lineTouchData2 => LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_1,
    /*lineChartBarData2_2,
    lineChartBarData2_3,*/
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text(value.toString(), style: style, textAlign: TextAlign.center);
  }

  /*Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Text(value.toString(), style: style, textAlign: TextAlign.center);
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }*/

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 30,
    reservedSize: 40,
  );

  /*Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(value.toString(), style: style,),
    );
  }*/

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    String mDate;
    double vprint=value;

    DateTime now = DateTime.parse("2023-05-07T16:50:00.000+00:00");
    now = now.subtract(Duration(seconds: value.toInt()));

    if(vprint<0)vprint*=-1;
    vprint>86400?{vprint/=86400, mDate="dias"}:vprint>3600?{vprint/=3600, mDate="hrs"}:vprint>60? {vprint/=60, mDate="min"}:mDate="segs";


    return isRelative? SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text("${vprint.toInt()} $mDate", style: style),
    ) : SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text("${now.hour}:${now.minute}", style: style),
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 12000,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  List<FlSpot> _composeData(){
    List<FlSpot> retr = [];
    data_list.forEach((element)=>retr.add(FlSpot(element[0],element[1])));
    return retr;
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.greenAccent,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: true),
    spots: _composeData(),
  );

  /*LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pinkAccent,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      color: Colors.pinkAccent.withOpacity(0),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
  );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Colors.cyanAccent,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(6, 3),
      FlSpot(10, 1.3),
      FlSpot(13, 2.5),
    ],
  );*/

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: Colors.blueAccent.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _composeData(),
  );

  /*LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pinkAccent.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.pinkAccent.withOpacity(0.2),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
  );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: Colors.cyanAccent.withOpacity(0.5),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 3.8),
      FlSpot(3, 1.9),
      FlSpot(6, 5),
      FlSpot(10, 3.3),
      FlSpot(13, 4.5),
    ],
  );*/
}

class LineChartDataByOffset extends StatefulWidget {
  final String title;
  final bool reversed;
  final bool isRelative;
  const LineChartDataByOffset({super.key,required this.title, required this.data_list,this.reversed=false, required this.isRelative});
  final List<List<double>> data_list;

  @override
  State<StatefulWidget> createState() => _DataByOffsetState1();
}

class _DataByOffsetState1 extends State<LineChartDataByOffset> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /*const SizedBox(
                height: 37,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),*/
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChartDataByOffset_LineChart1(isShowingMainData: isShowingMainData,data_list: widget.data_list,reversed: widget.reversed,isRelative: widget.isRelative),
                ),
              ),
              /*const SizedBox(
                height: 10,
              ),*/
            ],
          ),
          Align(
            alignment: Alignment.topRight,

            child: IconButton(
              icon: Icon(
                Icons.swap_horiz,
                color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}