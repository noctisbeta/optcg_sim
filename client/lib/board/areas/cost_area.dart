import 'package:client/constants.dart';
import 'package:flutter/material.dart';

class CostArea extends StatelessWidget {
  const CostArea({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    return Container(
      width: kCardHeight * 5 - kCardWidth - kPadding,
      height: kCardHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.grey[300],
      ),
      child: FittedBox(
        child: Text(
          'Cost',
          style: TextStyle(color: Colors.grey[400]!),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
