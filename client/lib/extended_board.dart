import 'package:client/board/board.dart';
import 'package:flutter/material.dart';

class ExtendedBoard extends StatelessWidget {
  const ExtendedBoard({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      children: [
        Expanded(child: Board(isOpponent: true)),
        Expanded(child: Board(isOpponent: false)),
      ],
    ),
  );
}
