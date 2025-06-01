import 'package:client/board/board.dart';
import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options_controller.dart';
import 'package:client/card_views/card_options_view.dart';
import 'package:client/card_views/highlighted_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_controller.dart';
import 'package:client/game_state/cards/card.dart' hide Card;
import 'package:client/game_state/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtendedBoard extends StatelessWidget {
  const ExtendedBoard({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: BlocBuilder<GameController, GameState>(
      builder: (context, state) => Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: RepositoryProvider.value(
                      value: state.opponent,
                      child: Board(
                        isOpponent: true,
                        isTurnPlayer: state.currentPlayer == state.opponent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RepositoryProvider.value(
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
                  context.read<GameController>().passTurn();
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
                  BlocBuilder<CardHighlightController, DeckCard?>(
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
                  BlocBuilder<CardOptionsController, DeckCard?>(
                    builder: (context, selectedCard) {
                      if (selectedCard == null) {
                        return const SizedBox.shrink();
                      }

                      return CardOptionsView(card: selectedCard);
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
  );
}
