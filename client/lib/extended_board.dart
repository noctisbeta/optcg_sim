import 'package:client/board/board.dart';
import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/card_options/card_options_state.dart';
import 'package:client/card_views/card_options/card_options_view.dart';
import 'package:client/card_views/highlighted_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtendedBoard extends StatelessWidget {
  const ExtendedBoard({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      if (context.read<SingleplayerGameController>().state.combatState !=
          CombatState.none) {
        return;
      }
      context.read<CardOptionsController>().clearSelection();
    },
    child: Center(
      child: BlocBuilder<SingleplayerGameController, GameState>(
        builder: (context, state) => MouseRegion(
          cursor: switch (state.combatState) {
            CombatState.attacking => SystemMouseCursors.precise,
            CombatState.countering => SystemMouseCursors.click,
            _ => SystemMouseCursors.basic,
          },
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: RepositoryProvider<Player>.value(
                          value: state.opponent,
                          child: Board(
                            isOpponent: true,
                            isTurnPlayer: state.currentPlayer == state.opponent,
                          ),
                        ),
                      ),
                      Expanded(
                        child: RepositoryProvider<Player>.value(
                          value: state.me,
                          child: Board(
                            isOpponent: false,
                            isTurnPlayer: state.currentPlayer == state.me,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.done_sharp),
                    onPressed: () {
                      context.read<SingleplayerGameController>().passTurn();
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Turn: ${state.turn}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<CardHighlightController, GameCard?>(
                        builder: (context, highlightedCard) {
                          if (highlightedCard == null) {
                            return const SizedBox(
                              width: kCardWidth * 4,
                              height: kCardHeight * 4,
                              child: Center(child: Text('No card selected')),
                            );
                          }

                          return SizedBox(
                            width: kCardWidth * 4,
                            height: kCardHeight * 4,
                            child: HighlightedCardView(card: highlightedCard),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<CardOptionsController, CardOptionsState>(
                        builder: (context, state) {
                          final GameCard? card = state.selectedCard;

                          return CardOptionsView(card: card);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (state.winner != null)
                Center(
                  child: Text(
                    '${state.winner!.name} wins!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
