import 'package:covid_charts/core/models/location.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class LineChartSample1 extends StatefulWidget {
  final List<Location> location;
  LineChartSample1({this.location});
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;
  List<Location> locationData=[];
  List<String> dates = [];
  List<List<FlSpot>> chartData = [[],[],[]];
  double max = 0;
  int a;

  @override
  void initState() {
    loadData();
    super.initState();
    a=0;
    isShowingMainData = true;
  }

  void loadData(){
    int dateWeek = 0;
    int dateMonth = 0;
    widget.location.sort((a,b)=> b.date.compareTo(a.date));
    for(int i=0; i<widget.location.length; i++){
      int week = weekNumber(widget.location[i].date);
    if( week != dateWeek ){ // get weeks
      locationData.add(widget.location[i]);
      dateWeek = week;
    }
    if (locationData.length > 11){break;}
    }
    locationData= List.from(locationData.reversed);
    dates =  List.from(dates.reversed);
   for(int j = 0; j<locationData.length; j++){
     chartData[0].add(FlSpot(j*1.0, locationData[j].number/1000.0));
     chartData[1].add(FlSpot(j*1.0, locationData[j].discharged/1000.0));
     chartData[2].add(FlSpot(j*1.0, locationData[j].deaths/1000.0));
     int a = locationData[j].number > locationData[j].deaths ? locationData[j].number : locationData[j].deaths;
     int b = a > locationData[j].discharged ? a : locationData[j].discharged;
     max = max > b ? max : (b * 1.0);
     if( locationData[j].date.month != dateMonth ){ // get months
       dates.add(getMonth(locationData[j].date.month));
       dateMonth = locationData[j].date.month;
     }
   }
    max = max/1000.0;
  }

  String getMonth(int date){
    switch(date){
      case 1 : return "JAN";
      case 2 : return "FEB";
      case 3 : return "MAR";
      case 4 : return "APR";
      case 5 : return "MAY";
      case 6 : return "JUNE";
      case 7 : return "JULY";
      case 8 : return "AUG";
      case 9 : return "SEPT";
      case 10 : return "OCT";
      case 11 : return "NOV";
      case 12 : return "DEC";
    }
        return "";
  }

  int weekNumber(DateTime date) {
   DateTime begin = DateTime(date.year,1,1);
    var weekNumber = date.difference(begin).inDays / 7;
    return weekNumber.round();
  }

  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
         color: Colors.transparent
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'NCDC COVID-19',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Monthly Data',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      isShowingMainData ? sampleData1() : sampleData2(),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Indicator(
                      color:   Color(0xff0293ee),
                      text: 'Infected',
                      isSquare: false,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      text: 'Recovered',
                      isSquare: false,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Indicator(
                      color: Colors.cyan,
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
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
          return  value% 4 == 0 ? value~/4 >= dates.length ? "":dates[value~/4]:"";
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
           if(value > 0 && value <=1.0){
             return '1k';
           }
           else if (value == max.round()/2){
             return '${value.toInt()}K';
           }
           else if (++value == max.round()){
             return '${value.toInt()}K';
           }
           else{
             return "";
           }
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: locationData.length * 1.0,
      maxY: max,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: chartData[0],
      isCurved: true,
      colors: [
        Color(0xff0293ee),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: chartData[1],
      isCurved: true,
      colors: [
        Color(0xfff8b250),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData lineChartBarData3 = LineChartBarData(
      spots: chartData[2],
      isCurved: true,
      colors: const [
        Colors.cyan,
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return   value% 4 == 0 ? value~/4 >= dates.length ? "":dates[value~/4]:"";
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            if(value > 0 && value <=1.0){
              return '1k';
            }
            else if (value == max.round()/2){
              return '${value.toInt()}K';
            }
            else if (++value == max.round()){
              return '${value.toInt()}K';
            }
            else{
              return "";
            }
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: locationData.length * 1.0,
      maxY: max,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: chartData[0],
        isCurved: true,
        curveSmoothness: 0,
        colors: [
          Color(0xff0293ee).withOpacity(0.6),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: chartData[1],
        isCurved: true,
        colors:  [
          Color(0xfff8b250).withOpacity(0.6),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: false, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),
      LineChartBarData(
        spots: chartData[2],
        isCurved: true,
        curveSmoothness: 0,
        colors:  [
          Colors.cyan.withOpacity(0.6),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}