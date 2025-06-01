import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options_controller.dart';
import 'package:client/card_views/character_card_view.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HandCardView extends StatelessWidget {
  const HandCardView({required this.card, super.key});

  final DeckCard card;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      context.read<CardOptionsController>().selectCard(card);
    },
    child: MouseRegion(
      onEnter: (_) =>
          context.read<CardHighlightController>().highlightCard(card),
      onExit: (_) => context.read<CardHighlightController>().clearHighlight(),
      child: switch (card) {
        CharacterCard() => CharacterCardView(
          card: card as CharacterCard,
        ),
        _ => const SizedBox.shrink(),
      },
    ),
  );
}
