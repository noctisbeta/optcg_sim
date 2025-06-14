// Card identifier
// ignore_for_file: camel_case_types

import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
final class OP10_005 extends CharacterCard with OnKO {
  const OP10_005({
    required super.id,
    required super.isActive,
    required super.isFrozen,
    required super.attachedDonCards,
  }) : super(
         name: 'Sanji',
         type: 'Punk Hazard/Straw Hat Crew',
         cost: 3,
         color: CardColor.red,
         cardNumber: 'OP10-005',
         blockNumber: 3,
         basePower: 3000,
         attributes: const [CardAttribute.special],
         counter: 1000,
       );

  @override
  int getEffectivePower({
    required bool isOnTurn,
    required int counterAmount,
    required CardLocation location,
  }) =>
      basePower +
      ((isOnTurn && location == CardLocation.characterArea) ? 3000 : 0) +
      (isOnTurn ? 0 : counterAmount) +
      attachedDonCards.fold(
        0,
        (sum, don) => sum + (don.isActive && isOnTurn ? 1000 : 0),
      );

  @override
  OP10_005 copyWith({
    int? id,
    String? name,
    String? type,
    int? cost,
    CardColor? color,
    String? cardNumber,
    int? blockNumber,
    int? basePower,
    List<CardAttribute>? attributes,
    bool? isFrozen,
    bool? isActive,
    int? counter,
    List<DonCard>? attachedDonCards,
  }) => OP10_005(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    isFrozen: isFrozen ?? this.isFrozen,
    attachedDonCards: attachedDonCards ?? this.attachedDonCards,
  );

  @override
  void onKO(
    GameState state,
    void Function(GameState state) emit,
    Player owner,
  ) {
    if (owner == state.me) {
      final DeckCard? drawnCard = state.me.deckCards.firstOrNull;
      final List<DeckCard> newDeckCards = state.me.deckCards.skip(1).toList();

      emit(
        state.copyWith(
          me: state.me.copyWith(
            handCards: [...state.me.handCards, ?drawnCard],
            deckCards: newDeckCards,
          ),
        ),
      );
    } else {
      final DeckCard? drawnCard = state.opponent.deckCards.firstOrNull;
      final List<DeckCard> newDeckCards = state.opponent.deckCards
          .skip(1)
          .toList();
      emit(
        state.copyWith(
          opponent: state.opponent.copyWith(
            handCards: [...state.opponent.handCards, ?drawnCard],
            deckCards: newDeckCards,
          ),
        ),
      );
    }
  }
}
