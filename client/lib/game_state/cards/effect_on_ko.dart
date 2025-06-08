part of 'game_card.dart';

mixin EffectOnKO on CharacterCard {
  void onKO(GameState state, void Function(GameState state) emit, Player owner);
}
