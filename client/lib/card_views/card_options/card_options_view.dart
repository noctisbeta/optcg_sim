import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/card_options/card_options_state.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsView extends StatelessWidget {
  const CardOptionsView({required this.card, super.key});

  final GameCard? card;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<SingleplayerGameController, GameState>(
    builder: (context, gameState) =>
        BlocBuilder<CardOptionsController, CardOptionsState>(
          builder: (context, state) => Column(
            children: [
              switch (gameState.interactionState) {
                ISnone() => const Text('Open game state'),

                ISchoosingAttackTarget() => const Text(
                  'Choose an attack target',
                ),

                IScountering() => const Text(
                  'Countering',
                ),

                ISattachingDon() => const Text(
                  'Attaching DON',
                ),
              },

              if (gameState.isAttachingDon &&
                  state.cardLocation == CardLocation.donArea) ...[
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<SingleplayerGameController>()
                        .donAttachController
                        .cancelDonSelection();
                    context.read<CardOptionsController>().clearSelection();
                  },
                  child: const Text('Cancel'),
                ),
              ],

              if (gameState.combatState == CombatState.countering) ...[
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<SingleplayerGameController>()
                        .combatController
                        .resolveCounter();
                  },
                  child: const Text('Resolve Counter'),
                ),
              ],
              if (state.cardLocation == CardLocation.characterArea) ...[
                if (gameState.turn > 2 &&
                    gameState.combatState == CombatState.none)
                  ElevatedButton(
                    onPressed: () async {
                      void afterAttack() {
                        context.read<CardOptionsController>().clearSelection();
                      }

                      await context
                          .read<SingleplayerGameController>()
                          .combatController
                          .attack(
                            card! as CharacterCard,
                          );

                      afterAttack();
                    },
                    child: const Text('Attack'),
                  ),
                if (gameState.combatState == CombatState.attacking)
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<SingleplayerGameController>()
                          .combatController
                          .cancelAttack();
                    },
                    child: const Text('Cancel Attack'),
                  ),
              ],
              if (state.cardLocation == CardLocation.handArea)
                ElevatedButton(
                  onPressed: () {
                    context.read<SingleplayerGameController>().playCard(
                      card! as DeckCard,
                    );

                    context.read<CardOptionsController>().clearSelection();
                  },
                  child: const Text('Deploy'),
                ),
              if (state.cardLocation == CardLocation.leaderArea) ...[
                if (gameState.turn > 2 &&
                    gameState.combatState == CombatState.none &&
                    (card! as LeaderCard).isActive)
                  ElevatedButton(
                    onPressed: () async {
                      void afterAttack() {
                        context.read<CardOptionsController>().clearSelection();
                      }

                      await context
                          .read<SingleplayerGameController>()
                          .combatController
                          .attack(
                            card!,
                          );

                      afterAttack();
                    },
                    child: const Text('Attack'),
                  ),
                if (gameState.combatState == CombatState.attacking)
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<SingleplayerGameController>()
                          .combatController
                          .cancelAttack();
                    },
                    child: const Text('Cancel Attack'),
                  ),
              ],
            ],
          ),
        ),
  );
}
