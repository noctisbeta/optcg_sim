import 'package:client/constants.dart';
import 'package:flutter/material.dart';

class DonArea extends StatelessWidget {
  const DonArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kCardWidth,
      height: kCardHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        color: Colors.grey[300],
      ),
      child: FittedBox(
        child: Text(
          'Don',
          style: TextStyle(color: Colors.grey[400]!),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
