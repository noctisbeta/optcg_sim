import 'package:client/card_views/highlight/highlighted_character_card_view.dart';
import 'package:client/card_views/highlight/highlighted_leader_card_view.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:flutter/material.dart' hide Card;

class HighlightedCardView extends StatelessWidget {
  const HighlightedCardView({required this.card, super.key});

  final GameCard card;

  @override
  Widget build(BuildContext context) => switch (card) {
    CharacterCard() => HighlightedCharacterCardView(
      card: card as CharacterCard,
    ),
    LeaderCard() => HighlightedLeaderCardView(
      leader: card as LeaderCard,
    ),
    _ => const SizedBox.shrink(),
  };
}
