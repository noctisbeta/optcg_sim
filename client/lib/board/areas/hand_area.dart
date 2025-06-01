import 'package:client/constants.dart';
import 'package:common/game_state/cards/card.dart'; // Assuming you have a base Card class or specific hand card type
import 'package:common/game_state/player.dart';
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
            // Card card = entry.value; // The card object, can be used to display card details or image later

            final double leftPosition =
                initialLeftOffset + (index * cardOverlapOffset);

            return Positioned(
              left: leftPosition,
              top: 0, // Align cards to the top of the HandArea
              child: Container(
                width: kCardWidth,
                height: kCardHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 1.5),
                  color: Colors
                      .deepPurple[300], // Placeholder color for hand cards
                  // Optional: rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Card', // Placeholder text
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize:
                          kCardHeight *
                          0.15, // Adjust font size based on card height
                      fontWeight: FontWeight.bold,
                    ),
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
