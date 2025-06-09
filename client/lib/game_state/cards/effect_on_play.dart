part of 'game_card.dart';

mixin EffectOnPlay on CharacterCard {
  void onPlay({
    required GameState state,
    required void Function(GameState state) emit,
    required Player owner,
  });
}

mixin OptionalEffectOnPlay on CharacterCard {
  void onPlay({
    required GameState state,
    required void Function(GameState state) emit,
    required Player owner,
    required bool shouldActivate,
  });
}
