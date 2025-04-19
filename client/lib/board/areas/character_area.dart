import 'package:client/constants.dart';
import 'package:flutter/material.dart';

class CharacterArea extends StatelessWidget {
  const CharacterArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;

    return Container(
      width: kCardHeight * 5,
      height: kCardHeight,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey[300]),
      child: FittedBox(
        child: Text(
          'Characters',
          style: TextStyle(color: Colors.grey[400]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
