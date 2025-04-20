import 'package:client/board/board.dart';
import 'package:client/game_controller.dart';
import 'package:common/game_state/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtendedBoard extends StatelessWidget {
  const ExtendedBoard({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: BlocBuilder<GameController, GameState>(
      builder:
          (context, state) => Column(
            children: [
              Expanded(
                child: RepositoryProvider(
                  create: (context) => state.opponent,
                  child: const Board(isOpponent: true),
                ),
              ),
              Expanded(
                child: RepositoryProvider(
                  create: (context) => state.me,
                  child: const Board(isOpponent: false),
                ),
              ),
            ],
          ),
    ),
  );
}
