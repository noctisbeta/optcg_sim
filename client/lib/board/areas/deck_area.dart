import 'package:client/constants.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeckArea extends StatefulWidget {
  const DeckArea({super.key});

  @override
  State<DeckArea> createState() => _DeckAreaState();
}

class _DeckAreaState extends State<DeckArea> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<DeckCard> cards = context.watch<Player>().deckCards;

    return MouseRegion(
      onHover: (_) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovering = false;
        });
      },
      child: Stack(
        children: [
          Container(
            width: kCardWidth,
            height: kCardHeight,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.grey[300],
            ),
            child: FittedBox(
              child: Text(
                isHovering
                    ? cards.length.toString()
                    : cards.isEmpty
                    ? 'Deck'
                    : '',
                style: TextStyle(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...cards.indexed.map(
            (tuple) => Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: kCardWidth,
                height: kCardHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  color: Colors.blueGrey[100],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: kCardWidth,
            height: kCardHeight,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.grey[300],
            ),
            child: FittedBox(
              child: Text(
                isHovering
                    ? cards.length.toString()
                    : cards.isEmpty
                    ? 'Deck'
                    : '',
                style: TextStyle(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
