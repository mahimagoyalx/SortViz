import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  CardView(this.colors, this.height, this.cardChild);

  final Color colors;
  final Widget cardChild;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardChild,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colors,
      ),
      margin: EdgeInsets.all(10.0),
    );
  }
}
