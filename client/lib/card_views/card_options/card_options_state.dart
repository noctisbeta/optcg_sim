import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class CardOptionsState {
  const CardOptionsState({
    required this.selectedCard,
    required this.cardType,
    required this.cardLocation,
  });

  final GameCard? selectedCard;
  final Type? cardType;
  final CardLocation? cardLocation;
}
