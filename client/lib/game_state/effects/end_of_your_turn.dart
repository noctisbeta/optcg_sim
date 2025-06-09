part of '../cards/game_card.dart';

mixin EndOfYourTurn on CharacterCard {
  Future<void> endOfYourTurn(
    GameState state,
    void Function(GameState state) emit,
    EffectController effectController,
    Player owner,
  );
}
