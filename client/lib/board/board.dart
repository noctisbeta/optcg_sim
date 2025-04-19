import 'package:client/board/areas/character_area.dart';
import 'package:client/board/areas/cost_area.dart';
import 'package:client/board/areas/deck_area.dart';
import 'package:client/board/areas/don_area.dart';
import 'package:client/board/areas/hand_area.dart';
import 'package:client/board/areas/leader_area.dart';
import 'package:client/board/areas/life_area.dart';
import 'package:client/board/areas/stage_area.dart';
import 'package:client/board/areas/trash_area.dart';
import 'package:client/constants.dart';
import 'package:client/util/list_extension.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({required this.isOpponent, super.key});

  final bool isOpponent;

  @override
  Widget build(BuildContext context) => Container(
    color: isOpponent ? Colors.pink[100] : Colors.lightGreen[100],
    child: Column(
      mainAxisAlignment:
          isOpponent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        const SizedBox(height: kPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                const LifeArea(),
                const SizedBox(height: kPadding),
              ].reverseWhen(isOpponent),
            ),
            const SizedBox(width: kPadding),
            Column(
              crossAxisAlignment:
                  isOpponent
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
              children: [
                const CharacterArea(),
                const SizedBox(height: kPadding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LeaderArea(),
                    const SizedBox(width: kPadding),
                    const StageArea(),
                    const SizedBox(width: kPadding),
                    const DeckArea(),
                  ].reverseWhen(isOpponent),
                ),
              ].reverseWhen(isOpponent),
            ),
          ].reverseWhen(isOpponent),
        ),
        const SizedBox(height: kPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          children:
              isOpponent
                  ? [
                    const TrashArea(),
                    const SizedBox(width: kPadding),
                    const CostArea(),
                    const SizedBox(width: kPadding),
                    const DonArea(),
                  ]
                  : [
                    const DonArea(),
                    const SizedBox(width: kPadding),
                    const CostArea(),
                    const SizedBox(width: kPadding),
                    const TrashArea(),
                  ],
        ),
        const SizedBox(height: kPadding),
        const HandArea(),
      ].reverseWhen(isOpponent),
    ),
  );
}
