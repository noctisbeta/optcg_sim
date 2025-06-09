import 'dart:math';

import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderCardView extends StatelessWidget {
  const LeaderCardView({required this.leader, super.key});

  final LeaderCard leader;

  @override
  Widget build(BuildContext context) {
    final SingleplayerGameController gameCubit = context
        .read<SingleplayerGameController>();

    final GameState gameState = gameCubit.state;

    final Player cardOwner = context.read<Player>();

    return GestureDetector(
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
            gameCubit.combatController.chooseAttackTarget(leader);
          case ISattachingDon():
            if (gameState.currentPlayer != cardOwner) {
              return;
            }
            gameCubit.donAttachController.attachDonCard(leader);
          case IScountering():
            return;
          case ISnone():
            context.read<CardOptionsController>().selectCard(
              leader,
              CardLocation.leaderArea,
            );
        }
      },
      child: Stack(
        children: [
          MouseRegion(
            onEnter: (_) =>
                context.read<CardHighlightController>().highlightCard(leader),
            onExit: (_) =>
                context.read<CardHighlightController>().clearHighlight(),
            child: Transform.rotate(
              angle: leader.isActive ? 0 : -pi / 2,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: leader.colors
                        .map(
                          (color) => switch (color) {
                            CardColor.red => Colors.red,
                            CardColor.blue => Colors.blue,
                            CardColor.green => Colors.green,
                            CardColor.yellow => Colors.yellow,
                            CardColor.purple => Colors.purple,
                            CardColor.black => Colors.black,
                          },
                        )
                        .toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      leader
                          .getEffectivePower(
                            counterAmount: context
                                .watch<SingleplayerGameController>()
                                .combatController
                                .getCounterAmountFor(leader),
                            isOnTurn:
                                context
                                    .watch<SingleplayerGameController>()
                                    .state
                                    .currentPlayer ==
                                context.watch<Player>(),
                          )
                          .toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      leader.name,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (leader.attachedDonCards.isNotEmpty)
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
                  '${leader.attachedDonCards.length}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
