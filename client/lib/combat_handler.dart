import 'dart:async';

import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class CombatHandler {
  CombatHandler({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  Completer<GameCard?>? _attackCompleter;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();
  void emit(GameState state) {
    _emit(state);
  }

  void cancelAttack() {
    _attackCompleter?.complete(null);
    _attackCompleter = null;
  }

  void chooseAttackTarget(GameCard? card) {
    if (card == null) {
      _attackCompleter?.complete(null);
      _attackCompleter = null;
      return;
    }

    _attackCompleter?.complete(card);
  }

  Future<void> attack(GameCard card) async {
    if (state.currentPlayer == state.me) {
      await _meAttackOpponent(card);
    } else {
      await _opponentAttackMe(card);
    }
  }

  Future<void> _opponentAttackMe(
    GameCard attackingCard,
  ) async {
    final GameState attackingState = state.copyWith(
      isAttacking: true,
    );

    emit(attackingState);

    _attackCompleter = Completer<GameCard?>();

    final GameCard? targetCard = await _attackCompleter?.future;

    switch (attackingCard) {
      case CharacterCard():
        final List<CharacterCard> newCharacterCards = [
          for (final character in state.opponent.characterCards)
            if (character == attackingCard)
              character.copyWith(isActive: false)
            else
              character,
        ];

        final Player newOpponent = state.opponent.copyWith(
          characterCards: newCharacterCards,
        );

        emit(state.copyWith(opponent: newOpponent, isAttacking: false));

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.me.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newMe = state.me.copyWith(
                characterCards: newCharacterCards,
              );

              emit(state.copyWith(me: newMe, isAttacking: false));
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power) {
              final List<DeckCard> meLifeCards = List.from(
                state.me.lifeCards,
              );

              final DeckCard takenLife = meLifeCards.removeAt(0);

              final List<DeckCard> newMeHandCards = [
                ...state.me.handCards,
                takenLife,
              ];

              final Player newMe = state.me.copyWith(
                lifeCards: meLifeCards,
                handCards: newMeHandCards,
              );

              emit(state.copyWith(me: newMe, isAttacking: false));
            }

          default:
            emit(state.copyWith(isAttacking: false));
        }

      case LeaderCard():
        final Player newOpponent = state.opponent.copyWith(
          leaderCard: state.opponent.leaderCard.copyWith(
            isActive: false,
          ),
        );

        emit(
          state.copyWith(opponent: newOpponent, isAttacking: false),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(state.copyWith(opponent: newOpponent, isAttacking: false));
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power) {
              final List<DeckCard> meLifeCards = List.from(
                state.me.lifeCards,
              );

              final DeckCard takenLife = meLifeCards.removeAt(0);

              final List<DeckCard> newMeHandCards = [
                ...state.me.handCards,
                takenLife,
              ];

              final Player newMe = state.me.copyWith(
                lifeCards: meLifeCards,
                handCards: newMeHandCards,
              );

              emit(state.copyWith(me: newMe, isAttacking: false));
            }

          default:
            emit(state.copyWith(isAttacking: false));
        }

      default:
        emit(state.copyWith(isAttacking: false));
        return;
    }
  }

  Future<void> _meAttackOpponent(GameCard attackingCard) async {
    final GameState attackingState = state.copyWith(
      isAttacking: true,
    );

    emit(attackingState);

    _attackCompleter = Completer<GameCard?>();

    final GameCard? targetCard = await _attackCompleter?.future;

    switch (attackingCard) {
      case CharacterCard():
        final List<CharacterCard> newCharacterCards = [
          for (final character in state.me.characterCards)
            if (character == attackingCard)
              character.copyWith(isActive: false)
            else
              character,
        ];

        final Player newMe = state.me.copyWith(
          characterCards: newCharacterCards,
        );

        emit(state.copyWith(me: newMe, isAttacking: false));

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(state.copyWith(opponent: newOpponent, isAttacking: false));
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power) {
              final List<DeckCard> opponentLifeCards = List.from(
                state.opponent.lifeCards,
              );

              final DeckCard takenLife = opponentLifeCards.removeAt(0);

              final List<DeckCard> newOpponentHandCards = [
                ...state.opponent.handCards,
                takenLife,
              ];

              final Player newOpponent = state.opponent.copyWith(
                lifeCards: opponentLifeCards,
                handCards: newOpponentHandCards,
              );

              emit(state.copyWith(opponent: newOpponent, isAttacking: false));
            }

          default:
            emit(state.copyWith(isAttacking: false));
        }

      case LeaderCard():
        final Player newMe = state.me.copyWith(
          leaderCard: state.me.leaderCard.copyWith(
            isActive: false,
          ),
        );

        emit(
          state.copyWith(me: newMe, isAttacking: false),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(state.copyWith(opponent: newOpponent, isAttacking: false));
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power) {
              final List<DeckCard> opponentLifeCards = List.from(
                state.opponent.lifeCards,
              );

              final DeckCard takenLife = opponentLifeCards.removeAt(0);

              final List<DeckCard> newOpponentHandCards = [
                ...state.opponent.handCards,
                takenLife,
              ];

              final Player newOpponent = state.opponent.copyWith(
                lifeCards: opponentLifeCards,
                handCards: newOpponentHandCards,
              );

              emit(state.copyWith(opponent: newOpponent, isAttacking: false));
            }

          default:
            emit(state.copyWith(isAttacking: false));
        }

      default:
        emit(state.copyWith(isAttacking: false));
        return;
    }
  }
}
