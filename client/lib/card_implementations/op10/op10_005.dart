// Card identifier
// ignore_for_file: camel_case_types

import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class OP10_005 extends CharacterCard {
  const OP10_005({required super.id})
    : super(
        name: 'Sanji',
        type: 'Punk Hazard / Straw Hat Crew',
        cost: 3,
        color: CardColor.red,
        cardNumber: 'OP10-005',
        blockNumber: 3,
        power: 3000,
        attributes: const [CardAttribute.special],
        isFrozen: false,
        isActive: true,
        counter: 1000,
      );
}
