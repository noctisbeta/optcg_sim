import 'package:meta/meta.dart';

import 'player.dart';

@immutable
final class GameState {
  const GameState({required this.me, required this.opponent});

  final Player me;
  final Player opponent;
}
