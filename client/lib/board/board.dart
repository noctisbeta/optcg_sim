import 'package:client/board/areas/character_area.dart';
import 'package:client/board/areas/cost_area.dart';
import 'package:client/board/areas/deck_area.dart';
import 'package:client/board/areas/don_area.dart';
import 'package:client/board/areas/leader_area.dart';
import 'package:client/board/areas/life_area.dart';
import 'package:client/board/areas/stage_area.dart';
import 'package:client/board/areas/trash_area.dart';
import 'package:client/util/list_extension.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  const Board({required this.isOpponent, super.key});

  final bool isOpponent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isOpponent ? Colors.pink[100] : Colors.lightGreen[100],
      child: Column(
        mainAxisAlignment:
            isOpponent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  LifeArea(),
                  const SizedBox(height: 12),
                ].reverseWhen(isOpponent),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment:
                    isOpponent
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  CharacterArea(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LeaderArea(),
                      const SizedBox(width: 12),
                      StageArea(),
                      const SizedBox(width: 12),
                      DeckArea(),
                    ].reverseWhen(isOpponent),
                  ),
                ].reverseWhen(isOpponent),
              ),
            ].reverseWhen(isOpponent),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                isOpponent
                    ? [
                      TrashArea(),
                      const SizedBox(width: 12),
                      CostArea(),
                      const SizedBox(width: 12),
                      DonArea(),
                    ]
                    : [
                      DonArea(),
                      const SizedBox(width: 12),
                      CostArea(),
                      const SizedBox(width: 12),
                      TrashArea(),
                    ],
          ),
        ].reverseWhen(isOpponent),
      ),
    );
  }
}
