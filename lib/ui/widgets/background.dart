import 'package:flutter/material.dart';
import 'package:covid_charts/utils/sizeConfig.dart';


class Base extends StatelessWidget {
  final Widget body;
  final int topFlex;
  final Color color;


  Base({this.body,@required this.topFlex,this.color});

  Widget topHalf(BuildContext context) {
    return new ConstrainedBox(
      child:  Container(
              decoration: new BoxDecoration(
                  color: color??Color.fromRGBO(245,  89, 37, 1.0)),constraints: BoxConstraints.expand(),
            ),constraints: BoxConstraints.tightFor(height: SizeConfig.blockSizeVertical*35 > 250 ? SizeConfig.blockSizeVertical*40  : 180 + SizeConfig.blockSizeVertical*17)
    );
  }

  final bottomHalf = new Flexible(
    child: new Container(color: Colors.white),fit: FlexFit.loose,
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
