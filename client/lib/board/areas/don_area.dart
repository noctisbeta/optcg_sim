import 'package:client/constants.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonArea extends StatefulWidget {
  const DonArea({super.key});

  @override
  State<DonArea> createState() => _DonAreaState();
}

class _DonAreaState extends State<DonArea> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double kCardHeight = (screenHeight - 10 * kPadding) / 8;
    final double kCardWidth = kCardHeight * kCardAspectRatio;
    final List<DonCard> cards = context.watch<Player>().donCards;

    return MouseRegion(
      onHover: (_) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovering = false;
        });
      },
      child: Container(
        width: kCardWidth,
        height: kCardHeight,
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.grey[300],
        ),
        child: FittedBox(
          child: Text(
            isHovering
                ? (GameState.maxDonCards - cards.length).toString()
                : 'Don',
            style: TextStyle(color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
