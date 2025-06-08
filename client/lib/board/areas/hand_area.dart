import 'package:client/card_views/hand_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HandArea extends StatelessWidget {
  const HandArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    final List<DeckCard> handCards = context.watch<Player>().handCards;

    // Factor to determine how much of each card is visible when stacked.
    const double cardOverlapFactor = 0.75; // Adjust for desired overlap in hand
    final double cardOverlapOffset = kCardWidth * cardOverlapFactor;

    // Calculate the total width the stack of cards will occupy.
    double currentCardsStackWidth = 0;
    if (handCards.isNotEmpty) {
      currentCardsStackWidth =
          kCardWidth + (handCards.length - 1) * cardOverlapOffset;
    }

    // The width of the parent container for the hand area.
    final double areaContainerWidth =
        kCardWidth * 2 + kPadding * 2 + kCardHeight * 5 - kCardWidth - kPadding;

    // Calculate the initial left offset to center the stack of cards.
    final double initialLeftOffset =
        (areaContainerWidth - currentCardsStackWidth) / 2;

    return Container(
      width: areaContainerWidth,
      height: kCardHeight,
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.blueGrey[100],
      ), // Slightly different color for hand
      child: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              child: Text(
                'Hand',
                style: TextStyle(color: Colors.blueGrey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Generate the stack of hand cards
          ...handCards.asMap().entries.map((entry) {
            final int index = entry.key;

            final double leftPosition =
                initialLeftOffset + (index * cardOverlapOffset);

            return Positioned(
              left: leftPosition,
              top: 0,
              child: SizedBox(
                width: kCardWidth,
                height: kCardHeight,
                child: HandCardView(card: entry.value as CharacterCard),
              ),
            );
          }),
        ],
      ),
    );
  }
}
