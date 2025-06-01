import 'package:client/card_views/character_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterArea extends StatelessWidget {
  const CharacterArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<CharacterCard> cards = context.watch<Player>().characterCards;

    return Stack(
      children: [
        Container(
          width: kCardHeight * 5,
          height: kCardHeight,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.grey[300],
          ),
          child: FittedBox(
            child: Text(
              'Characters',
              style: TextStyle(color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        ...cards.indexed.map(
          (tuple) => Positioned(
            left: kCardHeight - kCardWidth + tuple.$1 * kCardHeight,
            top: 0,
            child: SizedBox(
              width: kCardWidth,
              height: kCardHeight,
              child: CharacterCardView(card: tuple.$2),
            ),
          ),
        ),
      ],
    );
  }
}
