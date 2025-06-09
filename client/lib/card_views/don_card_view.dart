import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/constants.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonCardView extends StatelessWidget {
  const DonCardView({required this.card, super.key});

  final DonCard card;

  @override
  Widget build(BuildContext context) {
    final SingleplayerGameController gameCubit = context
        .watch<SingleplayerGameController>();

    final GameState gameState = gameCubit.state;

    final Player cardOwner = context.read<Player>();

    return GestureDetector(
      onTap: () {
        switch (gameState.interactionState) {
          case ISchoosingAttackTarget():
            return;
          case ISattachingDon():
            if (gameState.currentPlayer != cardOwner) {
              return;
            }
            gameCubit.donAttachController.toggleDonCardSelection(card);
          case IScountering():
            return;
          case ISnone():
            if (gameState.currentPlayer != cardOwner) {
              return;
            }

            context.read<CardOptionsController>().selectCard(
              card,
              CardLocation.donArea,
            );

            gameCubit.donAttachController.toggleDonCardSelection(card);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black54,
          ),
          color: Colors.yellow,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 3,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: const FittedBox(
          child: Padding(
            padding: EdgeInsets.all(
              kPadding / 2,
            ), // Padding for the text
            child: Text(
              'DON!!', // Updated text
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
