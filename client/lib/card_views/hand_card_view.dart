import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/character_card_view.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HandCardView extends StatelessWidget {
  const HandCardView({required this.card, super.key});

  final DeckCard card;

  @override
  Widget build(BuildContext context) {
    final SingleplayerGameController gameCubit = context
        .watch<SingleplayerGameController>();

    final GameState gameState = gameCubit.state;

    final Player cardOwner = context.read<Player>();

    return GestureDetector(
      onTap: () {
        switch (gameState.interactionState) {
          case ISconfirming():
            return;
          case ISchoosingAttackTarget():
            return;
          case ISattachingDon():
            return;
          case IScountering():
            if (gameState.combatState == CombatState.countering &&
                (gameState.currentPlayer != cardOwner)) {
              gameCubit.combatController.counter(
                card,
                cardOwner,
              );
            }
            return;
          case ISnone():
            if (gameState.currentPlayer != cardOwner) {
              return;
            }

            context.read<CardOptionsController>().selectCard(
              card,
              CardLocation.handArea,
            );
        }
      },
      child: MouseRegion(
        onEnter: (_) =>
            context.read<CardHighlightController>().highlightCard(card),
        onExit: (_) => context.read<CardHighlightController>().clearHighlight(),
        child: switch (card) {
          CharacterCard() => CharacterCardView(
            card: card as CharacterCard,
            location: CardLocation.handArea,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
