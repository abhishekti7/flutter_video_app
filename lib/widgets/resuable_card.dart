import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {

  ReusableCard({@required this.color, this.cardChild, this.onPress, this.borderRadius, this.margin});

  final Color color;
  final Widget cardChild;
  final Function onPress;
  final BorderRadius borderRadius;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius
        ),
      ),
    );
  }
}
