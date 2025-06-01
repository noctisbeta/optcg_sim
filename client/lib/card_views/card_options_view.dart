import 'package:client/game_controller.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsView extends StatelessWidget {
  const CardOptionsView({required this.card, super.key});

  final DeckCard card;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ElevatedButton(
        onPressed: () {
          context.read<GameController>().playCard(card);
        },
        child: const Text('Deploy'),
      ),
    ],
  );
}
