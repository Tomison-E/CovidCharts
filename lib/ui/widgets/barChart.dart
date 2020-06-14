import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:covid_charts/core/models/location.dart';

import 'indicator.dart';

class BarChartSample2 extends StatefulWidget {
  final List<Location> locations;

  BarChartSample2({this.locations});
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;
  final DateTime initialDate = DateTime(2020,2,27);

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;
  double max;

  @override
  void initState() {
    super.initState();
    sortData();
    showingBarGroups = rawBarGroups;
  }

  void sortData(){
  widget.locations.sort((a,b)=> b.date.compareTo(a.date));
  List<BarChartGroupData> items = [];
  int day;
  for(int i=0;i<widget.locations.length;i++){
    if(items.length == 7){
      break;
    }
     if (day == widget.locations[i].date.difference(initialDate).inDays){
       continue;
     }
     day = widget.locations[i].date.difference(initialDate).inDays;
    var barGroup = makeGroupData(day, widget.locations[i].number/1000.0, widget.locations[i].discharged/1000.0,widget.locations[i].deaths/1000.0);
    items.add(barGroup);
  }
  rawBarGroups = items;
   items.sort((a,b)=> b.barRods[0].y.compareTo(a.barRods[0].y));
   double a = items[0].barRods[0].y;
  items.sort((a,b)=> b.barRods[1].y.compareTo(a.barRods[1].y));
  double b = items[0].barRods[1].y;
  items.sort((a,b)=> b.barRods[2].y.compareTo(a.barRods[2].y));
  double c = items[0].barRods[2].y;
  double d = a > b ? a : b;
  double e = d > c ? d:c;

  max = e;

  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Daily',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'report',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: max,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex = response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is FlLongPressEnd ||
                                  response.touchInput is FlPanEnd) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                  in showingBarGroups[touchedGroupIndex].barRods) {
                                    sum += rod.y;
                                  }
                                  final avg =
                                      sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex].copyWith(
                                        barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                          return rod.copyWith(y: avg);
                                        }).toList(),
                                      );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color:  Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                          margin: 20,
                          getTitles: (double value) {
                            return "D ${rawBarGroups[value.toInt()].x}";
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == (max * 0.3).toInt()) {
                              return '${(max * 0.3).round()}K';
                            } else if (value == (max * 0.6).toInt()) {
                              return '${(max * 0.6).round()}K';
                            } else if (value == max.toInt()) {
                              return '${max.round()}K';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Indicator(
                    color:  Color(0xff53fdd7),
                    text: 'Infected',
                    isSquare: false,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Indicator(
                    color: Colors.lightBlue,
                    text: 'Recovered',
                    isSquare: false,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Indicator(
                    color: Colors.yellow,
                    text: 'Deaths',
                    isSquare: false,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2,double y3) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        y: y2,
        color: Colors.lightBlue,
        width: width,
      ),
      BarChartRodData(
        y: y3,
        color: Colors.yellow,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}