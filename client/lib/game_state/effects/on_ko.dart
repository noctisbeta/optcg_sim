part of '../cards/game_card.dart';

mixin OnKO on CharacterCard {
  void onKO(GameState state, void Function(GameState state) emit, Player owner);
}
