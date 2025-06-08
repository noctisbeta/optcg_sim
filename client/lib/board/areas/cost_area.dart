import 'dart:math';

import 'package:client/card_views/don_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CostArea extends StatelessWidget {
  const CostArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<DonCard> cards = context.watch<Player>().donCards;

    const double cardOverlapFactor = 0.40;
    final double cardOverlapOffset = kCardWidth * cardOverlapFactor;

    // The width of the parent container for the cost area.
    final double areaContainerWidth = kCardHeight * 5 - kCardWidth - kPadding;

    // Calculate the initial left offset to center the stack of cards.
    const double initialLeftOffset = 10;
    // (areaContainerWidth - currentCardsStackWidth) / 2;

    return Container(
      width: areaContainerWidth,
      height: kCardHeight,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey[300]),
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              child: Text(
                'Cost',
                style: TextStyle(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...cards.asMap().entries.map((entry) {
            final int index = entry.key;

            final double leftPosition =
                initialLeftOffset + (index * cardOverlapOffset);

            return Positioned(
              left: leftPosition,
              top: 0,
              child: Transform.rotate(
                angle: entry.value.isActive ? 0 : -pi / 2,
                child: SizedBox(
                  width: kCardWidth,
                  height: kCardHeight,
                  child: DonCardView(
                    card: entry.value,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
