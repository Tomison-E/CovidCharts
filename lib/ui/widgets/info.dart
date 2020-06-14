import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String image;
  final String title;
  final String detail;
  final Color color;
  final Color highlightColor;
  final action;
  final String label;
  
  Info({this.image,this.title,this.detail,this.color = Colors.white,this.action,this.highlightColor = Colors.black,this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(child: Center(child: Image.asset(image),),flex: 5,fit: FlexFit.loose),
         Flexible(child:  SingleChildScrollView(child:Center(child:RichText(text: TextSpan(text: "$title \n", style: TextStyle(color: Colors.black,fontSize: 25, fontWeight: FontWeight.bold),children: [
            TextSpan(text: detail,style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.normal))
          ]),textAlign: TextAlign.center))),flex: 3,fit: FlexFit.tight),
          Flexible(child: Center(child:SizedBox(child:RaisedButton(onPressed: action,color: highlightColor, textColor: color,child: Text(label,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),height: 50.0,width: double.infinity)),fit: FlexFit.loose,flex: 2,)
        ],
      ),
      padding: EdgeInsets.all(30.0),
    );
  }
  
  
  
}