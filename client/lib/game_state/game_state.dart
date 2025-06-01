import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class GameState {
  const GameState({
    required this.me,
    required this.opponent,
    required this.turn,
    required this.winner,
    required this.isAttacking,
  });

  GameState.empty()
    : me = Player.empty(),
      opponent = Player.empty2(),
      turn = 1,
      winner = null,
      isAttacking = false;

  static const int maxDonCards = 10;

  final Player me;
  final Player opponent;
  final int turn;
  final Player? winner;
  final bool isAttacking;

  Player get currentPlayer => turn.isOdd ? me : opponent;

  GameState copyWith({
    Player? me,
    Player? opponent,
    int? turn,
    Player? Function()? winnerFn,
    bool? isAttacking,
  }) => GameState(
    me: me ?? this.me,
    opponent: opponent ?? this.opponent,
    turn: turn ?? this.turn,
    winner: winnerFn != null ? winnerFn() : winner,
    isAttacking: isAttacking ?? this.isAttacking,
  );
}
