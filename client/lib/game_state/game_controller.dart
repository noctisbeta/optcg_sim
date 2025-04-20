import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class GameController extends Cubit<GameState> {
  GameController()
    : super(const GameState(me: Player.empty(), opponent: Player.empty()));
}
