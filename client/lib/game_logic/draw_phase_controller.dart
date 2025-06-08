import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class DrawPhaseController {
  DrawPhaseController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();

  void emit(GameState state) {
    _emit(state);
  }

  void drawPhase() {
    final DeckCard? drawnCard = state.currentPlayer.deckCards.firstOrNull;

    final List<DeckCard> newHandCards = [
      ...state.currentPlayer.handCards,
      ?drawnCard,
    ];

    final List<DeckCard> newDeckCards = state.currentPlayer.deckCards
        .skip(1)
        .toList();

    final Player newPlayer = state.currentPlayer.copyWith(
      handCards: newHandCards,
      deckCards: newDeckCards,
    );

    if (state.currentPlayer == state.me) {
      emit(state.copyWith(me: newPlayer));
    } else {
      emit(state.copyWith(opponent: newPlayer));
    }
  }
}
