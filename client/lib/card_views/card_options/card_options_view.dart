import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/card_options/card_options_state.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/singleplayer_game_controller.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsView extends StatelessWidget {
  const CardOptionsView({required this.card, super.key});

  final GameCard card;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<SingleplayerGameController, GameState>(
    builder: (context, gameState) =>
        BlocBuilder<CardOptionsController, CardOptionsState>(
          builder: (context, state) => Column(
            children: [
              if (state.cardLocation == CardLocation.characterArea) ...[
                ElevatedButton(
                  onPressed: () async {
                    void afterAttack() {
                      context.read<CardOptionsController>().clearSelection();
                    }

                    await context
                        .read<SingleplayerGameController>()
                        .attackWithCharacter(
                          card as CharacterCard,
                        );

                    afterAttack();
                  },
                  child: const Text('Attack'),
                ),
                if (gameState.isAttacking)
                  ElevatedButton(
                    onPressed: () {
                      context.read<SingleplayerGameController>().cancelAttack();
                    },
                    child: const Text('Cancel Attack'),
                  ),
              ],
              if (state.cardLocation == CardLocation.handArea)
                ElevatedButton(
                  onPressed: () {
                    context.read<SingleplayerGameController>().playCard(
                      card as DeckCard,
                    );

                    context.read<CardOptionsController>().clearSelection();
                  },
                  child: const Text('Deploy'),
                ),
              if (state.cardLocation == CardLocation.leaderArea) ...[
                ElevatedButton(
                  onPressed: () async {
                    void afterAttack() {
                      context.read<CardOptionsController>().clearSelection();
                    }

                    await context
                        .read<SingleplayerGameController>()
                        .attackWithLeader();

                    afterAttack();
                  },
                  child: const Text('Attack'),
                ),
                if (gameState.isAttacking)
                  ElevatedButton(
                    onPressed: () {
                      context.read<SingleplayerGameController>().cancelAttack();
                    },
                    child: const Text('Cancel Attack'),
                  ),
              ],
            ],
          ),
        ),
  );
}
