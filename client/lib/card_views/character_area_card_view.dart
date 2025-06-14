import 'dart:math';

import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/character_card_view.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterAreaCardView extends StatelessWidget {
  const CharacterAreaCardView({required this.card, super.key});

  final CharacterCard card;

  @override
  Widget build(BuildContext context) {
    final SingleplayerGameController gameCubit = context
        .watch<SingleplayerGameController>();

    final GameState gameState = gameCubit.state;

    final Player cardOwner = context.read<Player>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        switch (gameState.interactionState) {
          case ISselectingCardInHand():
            return;
          case ISconfirmingAction():
            return;
          case ISchoosingAttackTarget():
            if (gameState.currentPlayer == cardOwner) {
              return;
            }
            gameCubit.combatController.chooseAttackTarget(card);
          case ISattachingDon():
            if (gameState.currentPlayer != cardOwner) {
              return;
            }
            gameCubit.donAttachController.attachDonCard(card);
          case IScountering():
            return;
          case ISnone():
            context.read<CardOptionsController>().selectCard(
              card,
              CardLocation.characterArea,
            );
        }
      },
      child: Stack(
        children: [
          MouseRegion(
            onEnter: (_) =>
                context.read<CardHighlightController>().highlightCard(card),
            onExit: (_) =>
                context.read<CardHighlightController>().clearHighlight(),
            child: switch (card) {
              CharacterCard() => Transform.rotate(
                angle: card.isActive ? 0 : -pi / 2,
                child: CharacterCardView(
                  card: card,
                  location: CardLocation.characterArea,
                ),
              ),
            },
          ),
          if (card.attachedDonCards.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${card.attachedDonCards.length}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
