import 'package:covid_charts/utils/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_charts/core/models/region.dart';

class Animate extends StatefulWidget{
  final List<Day> days;

  Animate({this.days});
  @override
  State<StatefulWidget> createState() {
    return _Animate();
  }
}

class _Animate extends State<Animate> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  List<Animation<int>> variations=[];
  List<Animation<double>> rotations=[];
  List<Tween<double>> rotationsVal=[];
  List<Tween<int>> variationsVal=[];
  int i = 0;
  int maxLength;
  double unitPosition = 50.0;
  List<Day> total;
  int speed;

  @override
  void initState() {
    total = widget.days;
    speed=(30000/total.length).round();
    _controller =  AnimationController(
        duration:  Duration(milliseconds: speed),
        vsync: this
    );
     maxLength = 0;
      addVariation();
    _controller.addStatusListener((status){
      if(status == AnimationStatus.completed){
        i++;
        i<total.length? setNewPosition(i):i=-1;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }

  void refresh() {
   for (int i = 0; i < rotationsVal.length; i++) {
      rotationsVal[i].begin = rotationsVal[i].end;
      rotationsVal[i].end = (total[0].regions[i].position * unitPosition);
      variationsVal[i].begin = variationsVal[i].end;
      variationsVal[i].end = total[0].regions[i].infected;
    }
    i=0;
    _controller.reset();
    _controller.forward();
  }

  void addVariation(){
    int j = total.length-1;
    for (int i = 0; i < total[0].regions.length; i++) {
      Tween<int> decimalVariation =  IntTween(begin: total[j].regions[i].infected, end: total[0].regions[i].infected);
      Animation<int> _animation = decimalVariation.animate(
           CurvedAnimation(
              parent: _controller,
              curve:  Curves.ease,
              reverseCurve: Curves.ease
          ));
      Tween<double>  decimalVariations =  Tween<double>(begin:  (total[j].regions[i].position * unitPosition), end:(total[0].regions[i].position * unitPosition));
      Animation<double> _animations = decimalVariations.animate(
           CurvedAnimation(
              parent: _controller,
              curve:  Curves.ease,
              reverseCurve: Curves.ease
          ));

      rotations.add(_animations);
      rotationsVal.add(decimalVariations);
      variations.add(_animation);
      variationsVal.add(decimalVariation);
      maxLength = total[j].regions[i].infected > maxLength ? total[j].regions[i].infected : maxLength ;
    }
  }

  void setNewPosition(int i){
    rotate(total[i].regions);
    _controller.reset();
    _controller.forward();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:   Padding(padding: EdgeInsets.only(top:30,left: 5.0,right: 5.0),
            child:Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(right:10.0,left: 10.0), child:Row(children:[
              FloatingActionButton(onPressed: () {
              i < 0 ? refresh(): _controller.forward();
            },backgroundColor:i>0 && i<total.length-1?Colors.grey:Color.fromRGBO(245,  89, 37, 1.0),child:Icon(Icons.play_arrow,color: Colors.white),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)), ),//child: i>0 && i<total.length-1? Text("D ${i+1} ",style: TextStyle(color: Colors.white),): Icon(Icons.play_arrow)),
        Text(
            "Day ${i>0 && i<total.length-1?i+1:total.length} ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black45))
            ],mainAxisAlignment: MainAxisAlignment.spaceBetween)),
            AnimatedBuilder(animation: _controller, builder: (context,_)=>
    SizedBox(child:Stack(
                        children: total[total.length-1].regions.asMap().map((i,location) => MapEntry(i, Positioned(child: SizedBox(child:Padding(padding: EdgeInsets.only(left: 10,right:10 ),child:Row(children:[
                          Flexible(child:Text(
                            location.name,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45),
                          ) ,flex: 2,fit: FlexFit.tight),
                          Flexible(child:Container(height: 10.0,width: variations[i].value/( maxLength/(SizeConfig.blockSizeHorizontal*60)),decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Color.fromRGBO(245,  89, 37, 1.0)),),flex: 6,fit: FlexFit.loose),
                          Flexible(child:Text(
                            '${variations[i].value==0? 'nil':variations[i].value}',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45,),textAlign: TextAlign.right,
                          ) ,flex: 1,fit: FlexFit.tight)
                        ],mainAxisSize: MainAxisSize.min)),width: SizeConfig.blockSizeHorizontal*100),top: rotations[i].value))).values.toList()
                    ),height: (total[0].regions.length * unitPosition + unitPosition))),
            SizedBox(height: 10.0)
          ],)
        ),backgroundColor: Colors.transparent,
    );
  }

  rotate(List<Region> val ){
    for (int i = 0; i < val.length; i++) {
      rotationsVal[i].begin = rotationsVal[i].end;
      rotationsVal[i].end = val[i].position * unitPosition ;
      variationsVal[i].begin = variationsVal[i].end;
      variationsVal[i].end = val[i].infected;
    }
  }

}