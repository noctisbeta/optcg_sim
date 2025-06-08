part of 'game_card.dart';

mixin EffectOnPlay on CharacterCard {
  void onPlay(
    GameState state,
    void Function(GameState state) emit,
    Player owner,
  );
}
