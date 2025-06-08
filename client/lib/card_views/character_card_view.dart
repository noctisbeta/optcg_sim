import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterCardView extends StatelessWidget {
  const CharacterCardView({required this.card, super.key});

  final CharacterCard card;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => context.read<CardHighlightController>().highlightCard(card),
    onExit: (_) => context.read<CardHighlightController>().clearHighlight(),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        color: switch (card.color) {
          CardColor.red => Colors.red,
          CardColor.blue => Colors.blue,
          CardColor.green => Colors.green,
          CardColor.yellow => Colors.yellow,
          CardColor.purple => Colors.purple,
          CardColor.black => Colors.black,
        },
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                card.cost.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Text(
                card
                    .getEffectivePower(
                      counterAmount: context
                          .read<SingleplayerGameController>()
                          .combatController
                          .counterAmount,
                      isOnTurn:
                          context
                              .read<SingleplayerGameController>()
                              .state
                              .currentPlayer ==
                          context.read<Player>(),
                    )
                    .toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Center(
            child: Text(
              card.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          Text(
            'C${card.counter}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
