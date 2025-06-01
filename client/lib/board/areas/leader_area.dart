import 'package:client/card_views/leader/leader_card_view.dart';
import 'package:client/constants.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderArea extends StatelessWidget {
  const LeaderArea({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;

    final LeaderCard leaderCard = context.watch<Player>().leaderCard;

    return Container(
      width: kCardHeight,
      height: kCardHeight,
      decoration: BoxDecoration(border: Border.all(), color: Colors.grey[300]),
      child: Stack(
        children: [
          Center(
            child: FittedBox(
              child: Text(
                'Leader',
                style: TextStyle(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: kCardWidth,
              height: kCardHeight,
              child: LeaderCardView(leader: leaderCard),
            ),
          ),
        ],
      ),
    );
  }
}
