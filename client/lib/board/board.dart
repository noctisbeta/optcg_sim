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
  Widget build(BuildContext context) {
    return Container(
      color: isOpponent ? Colors.pink[100] : Colors.lightGreen[100],
      child: Column(
        mainAxisAlignment:
            isOpponent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          SizedBox(height: kPadding),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  LifeArea(),
                  SizedBox(height: kPadding),
                ].reverseWhen(isOpponent),
              ),
              SizedBox(width: kPadding),
              Column(
                crossAxisAlignment:
                    isOpponent
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  CharacterArea(),
                  SizedBox(height: kPadding),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LeaderArea(),
                      SizedBox(width: kPadding),
                      StageArea(),
                      SizedBox(width: kPadding),
                      DeckArea(),
                    ].reverseWhen(isOpponent),
                  ),
                ].reverseWhen(isOpponent),
              ),
            ].reverseWhen(isOpponent),
          ),
          SizedBox(height: kPadding),
          Row(
            mainAxisSize: MainAxisSize.min,
            children:
                isOpponent
                    ? [
                      TrashArea(),
                      SizedBox(width: kPadding),
                      CostArea(),
                      SizedBox(width: kPadding),
                      DonArea(),
                    ]
                    : [
                      DonArea(),
                      SizedBox(width: kPadding),
                      CostArea(),
                      SizedBox(width: kPadding),
                      TrashArea(),
                    ],
          ),
          SizedBox(height: kPadding),
          HandArea(),
        ].reverseWhen(isOpponent),
      ),
    );
  }
}
