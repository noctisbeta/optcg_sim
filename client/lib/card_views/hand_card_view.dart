import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/character_card_view.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HandCardView extends StatelessWidget {
  const HandCardView({required this.card, super.key});

  final DeckCard card;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      if (context.read<SingleplayerGameController>().state.combatState ==
              CombatState.countering &&
          (context.read<SingleplayerGameController>().state.currentPlayer !=
              context.read<Player>())) {
        context.read<SingleplayerGameController>().combatController.counter(
          card,
          context.read<Player>(),
        );
      }

      if (context.read<SingleplayerGameController>().state.currentPlayer !=
          context.read<Player>()) {
        return;
      }

      if (context.read<SingleplayerGameController>().state.combatState !=
              CombatState.none &&
          context.read<SingleplayerGameController>().state.currentPlayer ==
              context.read<Player>()) {
        return;
      }

      context.read<CardOptionsController>().selectCard(
        card,
        CardLocation.handArea,
      );
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
