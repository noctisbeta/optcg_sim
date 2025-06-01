import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/character_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrashArea extends StatelessWidget {
  const TrashArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<DeckCard> cards = context.watch<Player>().trashCards;

    return Stack(
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
              'Trash',
              style: TextStyle(color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ...cards.indexed.map(
          (tuple) => Positioned(
            left: 0,
            top: 0,
            child: SizedBox(
              width: kCardWidth,
              height: kCardHeight,
              child: MouseRegion(
                onEnter: (_) => context
                    .read<CardHighlightController>()
                    .highlightCard(tuple.$2),
                onExit: (_) =>
                    context.read<CardHighlightController>().clearHighlight(),
                child: switch (tuple.$2) {
                  CharacterCard() => CharacterCardView(
                    card: tuple.$2 as CharacterCard,
                  ),

                  _ => const SizedBox.shrink(),
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
