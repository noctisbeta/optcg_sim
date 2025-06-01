import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class GameState {
  const GameState({
    required this.me,
    required this.opponent,
    required this.turn,
    required this.winner,
    required this.combatState,
  });

  GameState.empty()
    : me = Player.empty(),
      opponent = Player.empty2(),
      turn = 1,
      winner = null,
      combatState = CombatState.none;

  static const int maxDonCards = 10;

  final Player me;
  final Player opponent;
  final int turn;
  final Player? winner;
  final CombatState combatState;

  Player get currentPlayer => turn.isOdd ? me : opponent;

  GameState copyWith({
    Player? me,
    Player? opponent,
    int? turn,
    Player? Function()? winnerFn,
    CombatState? combatState,
  }) => GameState(
    me: me ?? this.me,
    opponent: opponent ?? this.opponent,
    turn: turn ?? this.turn,
    winner: winnerFn != null ? winnerFn() : winner,
    combatState: combatState ?? this.combatState,
  );
}
