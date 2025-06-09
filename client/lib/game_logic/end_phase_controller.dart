import 'package:client/game_logic/effect_controller.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class EndPhaseController {
  EndPhaseController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
    required EffectController effectController,
  }) : _emit = emit,
       _getState = getState,
       _effectController = effectController;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  final EffectController _effectController;

  GameState get state => _getState();

  void emit(GameState state) {
    _emit(state);
  }

  Future<void> endPhase() async {
    final Player endPlayer = state.currentPlayer;

    final List<CharacterCard> characters = endPlayer.characterCards;

    for (final character in characters) {
      switch (character) {
        case EndOfYourTurn():
          await character.endOfYourTurn(
            state,
            emit,
            _effectController,
            endPlayer,
          );
      }
    }
  }
}
