import 'package:client/constants.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameArea extends StatelessWidget {
  const NameArea({required this.isOpponent, super.key});

  final bool isOpponent;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final String name = context.watch<Player>().name;
    return Container(
      width: kCardWidth * 3,
      height: kCardHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: isOpponent ? Colors.pink[300]! : Colors.green[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(kCardHeight / 2),
        color: isOpponent ? Colors.pink[200] : Colors.green[100],
      ),
      child: FittedBox(
        child: Text(
          name,
          style: TextStyle(
            color: isOpponent ? Colors.pink[900] : Colors.green[900],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
