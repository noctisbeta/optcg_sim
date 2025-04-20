import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';

@immutable
final class GameState {
  const GameState({required this.me, required this.opponent});

  final Player me;
  final Player opponent;
}
