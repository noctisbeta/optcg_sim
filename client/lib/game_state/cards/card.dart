import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:flutter/material.dart' show immutable;

part 'character_card.dart';
part 'deck_card.dart';
part 'don_card.dart';
part 'leader_card.dart';
part 'stage_card.dart';

sealed class GameCard {
  const GameCard({
    required this.id,
  });

  final int id;
}
