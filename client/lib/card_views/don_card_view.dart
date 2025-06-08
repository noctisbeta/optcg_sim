import 'package:client/card_views/card_options/card_options_controller.dart';
import 'package:client/constants.dart';
import 'package:client/game_logic/singleplayer_game_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonCardView extends StatelessWidget {
  const DonCardView({required this.card, super.key});

  final DonCard card;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      context.read<CardOptionsController>().selectCard(
        card,
        CardLocation.donArea,
      );

      context
          .read<SingleplayerGameController>()
          .donAttachController
          .selectDonCard(card);
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
        ),
        color: Colors.yellow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: const FittedBox(
        child: Padding(
          padding: EdgeInsets.all(
            kPadding / 2,
          ), // Padding for the text
          child: Text(
            'DON!!', // Updated text
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
