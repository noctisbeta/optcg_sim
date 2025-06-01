import 'package:client/card_views/character_card_view.dart';
import 'package:client/card_views/leader/leader_card_view.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:flutter/material.dart' hide Card;

class HighlightedCardView extends StatelessWidget {
  const HighlightedCardView({required this.card, super.key});

  final GameCard card;

  @override
  Widget build(BuildContext context) => switch (card) {
    CharacterCard() => CharacterCardView(
      card: card as CharacterCard,
    ),
    LeaderCard() => LeaderCardView(
      leader: card as LeaderCard,
    ),
    _ => const SizedBox.shrink(),
  };
}
