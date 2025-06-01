import 'dart:math';

import 'package:client/card_views/card_highlight_controller.dart';
import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/player.dart';
import 'package:client/singleplayer_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderCardView extends StatelessWidget {
  const LeaderCardView({required this.leader, super.key});

  final LeaderCard leader;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      if (context.read<SingleplayerGameController>().state.combatState ==
          CombatState.attacking) {
        context.read<SingleplayerGameController>().chooseAttackTarget(leader);
      }

      if (context.read<SingleplayerGameController>().state.currentPlayer !=
          context.read<Player>()) {
        return;
      }

      context.read<CardOptionsController>().selectCard(
        leader,
        CardLocation.leaderArea,
      );
    },
    child: MouseRegion(
      onEnter: (_) =>
          context.read<CardHighlightController>().highlightCard(leader),
      onExit: (_) => context.read<CardHighlightController>().clearHighlight(),
      child: Transform.rotate(
        angle: leader.isActive ? 0 : -pi / 2,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: leader.colors
                  .map(
                    (color) => switch (color) {
                      CardColor.red => Colors.red,
                      CardColor.blue => Colors.blue,
                      CardColor.green => Colors.green,
                      CardColor.yellow => Colors.yellow,
                      CardColor.purple => Colors.purple,
                      CardColor.black => Colors.black,
                    },
                  )
                  .toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Text(
                leader.power.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Text(
                leader.name,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
