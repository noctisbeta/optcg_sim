import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class GameState {
  const GameState({
    required this.me,
    required this.opponent,
    required this.turn,
    required this.winner,
  });

  GameState.empty()
    : me = Player.empty(),
      opponent = Player.empty2(),
      turn = 1,
      winner = null;

  static const int maxDonCards = 10;

  final Player me;
  final Player opponent;
  final int turn;
  final Player? winner;

  Player get currentPlayer => turn.isOdd ? me : opponent;

  GameState copyWith({
    Player? me,
    Player? opponent,
    int? turn,
    Player? winner,
  }) => GameState(
    me: me ?? this.me,
    opponent: opponent ?? this.opponent,
    turn: turn ?? this.turn,
    winner: winner ?? this.winner,
  );
}
