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
final class OP10_112 extends CharacterCard with EffectOnPlay {
  const OP10_112({
    required super.id,
    required super.isActive,
    required super.isFrozen,
    required super.attachedDonCards,
  }) : super(
         name: 'Eustass"Captain"Kid',
         type: 'Supernovas/Kid Pirates',
         cost: 8,
         color: CardColor.yellow,
         cardNumber: 'OP10-112',
         blockNumber: 3,
         basePower: 9000,
         attributes: const [CardAttribute.special],
         counter: 0,
       );

  @override
  int getEffectivePower({
    required bool isOnTurn,
    required int counterAmount,
    required CardLocation location,
  }) =>
      basePower +
      (isOnTurn ? 0 : counterAmount) +
      attachedDonCards.fold(
        0,
        (sum, don) => sum + (don.isActive && isOnTurn ? 1000 : 0),
      );

  @override
  OP10_112 copyWith({
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
  }) => OP10_112(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    isFrozen: isFrozen ?? this.isFrozen,
    attachedDonCards: attachedDonCards ?? this.attachedDonCards,
  );

  @override
  void onPlay(
    GameState state,
    void Function(GameState state) emit,
    Player owner,
  ) {
    if (owner == state.me) {
      final DeckCard? trashedLife = state.opponent.lifeCards.firstOrNull;
      final List<DeckCard> newLifeCards = state.opponent.lifeCards
          .skip(1)
          .toList();

      final List<CharacterCard> newCharacterCards = [
        for (final char in state.me.characterCards)
          if (char.id == id) char.copyWith(isActive: false) else char,
      ];

      emit(
        state.copyWith(
          me: state.me.copyWith(
            characterCards: newCharacterCards,
          ),
          opponent: state.opponent.copyWith(
            trashCards: [...state.opponent.trashCards, ?trashedLife],
            lifeCards: newLifeCards,
          ),
        ),
      );
    } else {
      final DeckCard? trashedLife = state.me.lifeCards.firstOrNull;
      final List<DeckCard> newLifeCards = state.me.lifeCards.skip(1).toList();

      final List<CharacterCard> newCharacterCards = [
        for (final char in state.opponent.characterCards)
          if (char.id == id) char.copyWith(isActive: false) else char,
      ];

      emit(
        state.copyWith(
          opponent: state.opponent.copyWith(
            characterCards: newCharacterCards,
          ),
          me: state.me.copyWith(
            trashCards: [...state.me.trashCards, ?trashedLife],
            lifeCards: newLifeCards,
          ),
        ),
      );
    }
  }
}
