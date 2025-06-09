import 'package:client/game_logic/effect_controller.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' show immutable;

part '../effects/end_of_your_turn.dart';
part '../effects/on_ko.dart';
part '../effects/on_play.dart';
part 'character_card.dart';
part 'deck_card.dart';
part 'don_attachable.dart';
part 'don_card.dart';
part 'leader_card.dart';
part 'stage_card.dart';

sealed class GameCard {
  const GameCard({
    required this.id,
  });

  final int id;
}
