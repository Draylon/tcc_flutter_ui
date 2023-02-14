import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class PieChartSample2 extends StatefulWidget {
  final String text_type;
  final double val;
  final double max;
  final double min;
  final double radius_gap_percentage;
  const PieChartSample2({super.key,required this.radius_gap_percentage,required this.text_type,required this.val,required this.min,required this.max});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          turns: AlwaysStoppedAnimation(
              (90 - (widget.radius_gap_percentage*360)/2)/360
          ),
          child: SizedBox.square(
              dimension: 170,
              child:AspectRatio(
                aspectRatio: 1.0,
                child: Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            /*pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),*/
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            startDegreeOffset: 0,
                            centerSpaceRadius: 70,
                            sections: showingSections(),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
          ),
        ),
        Center(
          child: Text(widget.text_type,style: TextStyle(
              fontSize: 30
          ),),
        )
      ],
    );
  }
  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 5.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.transparent,
            value: 100*widget.radius_gap_percentage,
            showTitle: false,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value:  ((widget.val - widget.min) * (100 - 100*widget.radius_gap_percentage)) / (widget.max - widget.min),
            showTitle: false,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blueGrey,
            value: (100*(1-widget.radius_gap_percentage))-(((widget.val - widget.min) * (100 - 100*widget.radius_gap_percentage)) / (widget.max - widget.min)),
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}