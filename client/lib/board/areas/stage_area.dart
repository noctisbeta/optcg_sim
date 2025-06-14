import 'dart:math';

import 'package:client/constants.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageArea extends StatelessWidget {
  const StageArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    final StageCard? stageCard = context.watch<Player>().stageCard;

    return Container(
      width: kCardHeight,
      height: kCardHeight,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey[300]),
      child: Stack(
        children: [
          Center(
            child: FittedBox(
              child: Text(
                'Stage',
                style: TextStyle(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Transform.rotate(
              angle: -pi / 2,
              child: Container(
                width: kCardWidth,
                height: kCardHeight,
                color: switch (stageCard?.color) {
                  CardColor.red => Colors.red,
                  CardColor.blue => Colors.blue,
                  CardColor.green => Colors.green,
                  CardColor.yellow => Colors.yellow,
                  CardColor.purple => Colors.purple,
                  CardColor.black => Colors.black,
                  null => Colors.transparent,
                },
                padding: const EdgeInsets.all(8),
                child: Text(
                  stageCard?.name ?? '',
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
