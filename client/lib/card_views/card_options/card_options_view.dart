import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/card_views/card_options/card_options_state.dart';
import 'package:client/game_controller.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsView extends StatelessWidget {
  const CardOptionsView({required this.card, super.key});

  final GameCard card;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CardOptionsController, CardOptionsState>(
        builder: (context, state) => Column(
          children: [
            if (state.cardLocation == CardLocation.handArea)
              ElevatedButton(
                onPressed: () {
                  context.read<GameController>().playCard(card as DeckCard);
                },
                child: const Text('Deploy'),
              ),
            if (state.cardLocation == CardLocation.leaderArea)
              ElevatedButton(
                onPressed: () {
                  context.read<GameController>().attackWithLeader();
                },
                child: const Text('Attack'),
              ),
          ],
        ),
      );
}
