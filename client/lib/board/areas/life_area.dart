import 'package:client/constants.dart';
import 'package:flutter/material.dart';

class LifeArea extends StatelessWidget {
  const LifeArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    return Container(
      width: kCardWidth,
      height: kCardHeight * 2,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey[300]),
      child: FittedBox(
        child: Text(
          'L\ni\nf\ne\n',
          style: TextStyle(color: Colors.grey[400]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
