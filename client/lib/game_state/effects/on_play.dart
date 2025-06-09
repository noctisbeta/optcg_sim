part of '../cards/game_card.dart';

mixin OnPlay on CharacterCard {
  void onPlay({
    required GameState state,
    required void Function(GameState state) emit,
    required Player owner,
  });
}

mixin OptionalOnPlay on CharacterCard {
  void onPlay({
    required GameState state,
    required void Function(GameState state) emit,
    required Player owner,
    required bool shouldActivate,
  });
}
