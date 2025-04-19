import 'package:client/constants.dart';
import 'package:flutter/material.dart';

class LeaderArea extends StatelessWidget {
  const LeaderArea({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    return Container(
      width: kCardWidth,
      height: kCardHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.grey[300],
      ),
      child: FittedBox(
        child: Text(
          'Leader',
          style: TextStyle(color: Colors.grey[400]!),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
