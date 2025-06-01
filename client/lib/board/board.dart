import 'package:client/board/areas/character_area.dart';
import 'package:client/board/areas/cost_area.dart';
import 'package:client/board/areas/deck_area.dart';
import 'package:client/board/areas/don_area.dart';
import 'package:client/board/areas/hand_area.dart';
import 'package:client/board/areas/leader_area.dart';
import 'package:client/board/areas/life_area.dart';
import 'package:client/board/areas/name_area.dart';
import 'package:client/board/areas/stage_area.dart';
import 'package:client/board/areas/trash_area.dart';
import 'package:client/constants.dart';
import 'package:client/util/list_extension.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({
    required this.isOpponent,
    required this.isTurnPlayer,
    super.key,
  });

  final bool isOpponent;
  final bool isTurnPlayer;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: kPadding),
    decoration: BoxDecoration(
      color: isOpponent ? Colors.pink[100] : Colors.lightGreen[100],
      border: Border.symmetric(
        vertical: BorderSide(
          color: isOpponent ? Colors.pink[300]! : Colors.lightGreen[300]!,
          width: isTurnPlayer ? 5 : 1,
        ),
        horizontal: BorderSide(
          color: isOpponent ? Colors.pink[300]! : Colors.lightGreen[300]!,
        ),
      ),
    ),
    child: Column(
      mainAxisAlignment: isOpponent
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
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
              crossAxisAlignment: isOpponent
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                const CharacterArea(),
                const SizedBox(height: kPadding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NameArea(isOpponent: isOpponent),
                    const SizedBox(width: kPadding),
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
          children: isOpponent
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
