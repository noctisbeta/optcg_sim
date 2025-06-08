import 'package:client/constants.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LifeArea extends StatelessWidget {
  const LifeArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<DeckCard> cards = context.watch<Player>().lifeCards;

    // Overlap factor: e.g., 0.2 means each card is offset by 20% of its height
    const double cardOverlapFactor = 0.50;
    final double cardOverlapOffset =
        (kCardHeight / 2) *
        cardOverlapFactor; // Life cards are shown at half height

    // Calculate the total height the stack of life cards will occupy
    double currentCardsStackHeight = 0;
    if (cards.isNotEmpty) {
      currentCardsStackHeight =
          (kCardHeight / 2) + (cards.length - 1) * cardOverlapOffset;
    }
    // or a minimal height if no cards.
    currentCardsStackHeight = cards.isEmpty
        ? kCardHeight / 2
        : currentCardsStackHeight;

    final double areaContainerHeight = kCardHeight * 2;

    return SizedBox(
      // Use SizedBox to constrain the overall area if needed
      width: kCardWidth,
      height:
          areaContainerHeight, // Use calculated or a fixed reasonable height
      child: Stack(
        alignment: Alignment.topCenter, // Align stack to the top center
        children: [
          Container(
            width: kCardWidth,
            height: areaContainerHeight, // Match the SizedBox height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              color: Colors.grey[300],
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kPadding / 2),
                child: Text(
                  'L\ni\nf\ne', // Removed trailing \n
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Generate the stack of facedown life cards
          ...cards.asMap().entries.map(
            (entry) {
              final int index = entry.key;
              // final DeckCard card = entry.value; // Card data not shown

              final double topPosition = index * cardOverlapOffset;

              return Positioned(
                bottom: topPosition,
                child: Container(
                  width: kCardWidth * 0.9,
                  height: kCardHeight / 2,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700], // Facedown card color
                    border: Border.all(color: Colors.black54, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // No child needed as cards are facedown
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
