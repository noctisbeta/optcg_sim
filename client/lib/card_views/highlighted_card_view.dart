import 'package:client/card_views/character_card_view.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:flutter/material.dart' hide Card;

class HighlightedCardView extends StatelessWidget {
  const HighlightedCardView({required this.card, super.key});

  final Card card;

  @override
  Widget build(BuildContext context) => switch (card) {
    CharacterCard() => CharacterCardView(
      card: card as CharacterCard,
    ),
    _ => const SizedBox.shrink(),
  };
}
