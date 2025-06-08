import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class DonPhaseController {
  DonPhaseController({
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

  void donPhase() {
    final Player newPlayer = state.currentPlayer.copyWith(
      donCards: [
        ...state.currentPlayer.donCards,
        if (state.currentPlayer.donCards.length < GameState.maxDonCards)
          DonCard(
            id: state.currentPlayer.donCards.length + 1,
            isActive: true,
            isFrozen: false,
          ),
        if (state.currentPlayer.donCards.length + 1 < GameState.maxDonCards)
          DonCard(
            id: state.currentPlayer.donCards.length + 1,
            isActive: true,
            isFrozen: false,
          ),
      ],
    );

    if (state.currentPlayer == state.me) {
      emit(state.copyWith(me: newPlayer));
    } else {
      emit(state.copyWith(opponent: newPlayer));
    }
  }
}
