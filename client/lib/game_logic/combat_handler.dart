import 'dart:async';

import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class CombatHandler {
  CombatHandler({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  Completer<GameCard?>? _attackCompleter;
  Completer<int?>? _counterCompleter;
  int _counterAmount = 0;

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

  void counter(DeckCard card, Player player) {
    if (card is CharacterCard) {
      _counterAmount = _counterAmount + card.counter;
    }

    if (player == state.me) {
      final List<DeckCard> newHandCards = [
        for (final handCard in state.me.handCards)
          if (handCard != card) handCard,
      ];

      final List<DeckCard> newTrashCards = [
        ...state.me.trashCards,
        card,
      ];

      final Player newMe = state.me.copyWith(
        handCards: newHandCards,
        trashCards: newTrashCards,
      );

      emit(state.copyWith(me: newMe, combatState: CombatState.countering));
    } else {
      final List<DeckCard> newHandCards = [
        for (final handCard in state.opponent.handCards)
          if (handCard != card) handCard,
      ];

      final List<DeckCard> newTrashCards = [
        ...state.opponent.trashCards,
        card,
      ];

      final Player newOpponent = state.opponent.copyWith(
        handCards: newHandCards,
        trashCards: newTrashCards,
      );

      emit(
        state.copyWith(
          opponent: newOpponent,
          combatState: CombatState.countering,
        ),
      );
    }
  }

  void resolveCounter() {
    _counterCompleter?.complete(_counterAmount);
    _counterCompleter = null;
    _counterAmount = 0;
  }

  Future<void> attack(GameCard card) async {
    if (state.turn < 3) {
      return;
    }

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
      combatState: CombatState.attacking,
    );

    emit(attackingState);

    _attackCompleter = Completer<GameCard?>();

    final GameCard? targetCard = await _attackCompleter?.future;

    emit(state.copyWith(combatState: CombatState.countering));

    _counterCompleter = Completer<int?>();

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

        emit(
          state.copyWith(
            opponent: newOpponent,
            combatState: CombatState.countering,
          ),
        );

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.me.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newMe = state.me.copyWith(
                characterCards: newCharacterCards,
              );

              emit(state.copyWith(me: newMe, combatState: CombatState.none));
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
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

              emit(state.copyWith(me: newMe, combatState: CombatState.none));
            }

          default:
            emit(state.copyWith(combatState: CombatState.none));
        }

      case LeaderCard():
        final Player newOpponent = state.opponent.copyWith(
          leaderCard: state.opponent.leaderCard.copyWith(
            isActive: false,
          ),
        );

        emit(
          state.copyWith(
            opponent: newOpponent,
            combatState: CombatState.countering,
          ),
        );

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(
                state.copyWith(
                  opponent: newOpponent,
                  combatState: CombatState.none,
                ),
              );
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
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

              emit(state.copyWith(me: newMe, combatState: CombatState.none));
            }
          default:
            emit(state.copyWith(combatState: CombatState.none));
        }

      default:
        emit(state.copyWith(combatState: CombatState.none));
        return;
    }
  }

  Future<void> _meAttackOpponent(GameCard attackingCard) async {
    final GameState attackingState = state.copyWith(
      combatState: CombatState.attacking,
    );

    emit(attackingState);

    _attackCompleter = Completer<GameCard?>();

    final GameCard? targetCard = await _attackCompleter?.future;

    emit(state.copyWith(combatState: CombatState.countering));

    _counterCompleter = Completer<int?>();

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

        emit(state.copyWith(me: newMe, combatState: CombatState.countering));

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(
                state.copyWith(
                  opponent: newOpponent,
                  combatState: CombatState.none,
                ),
              );
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
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

              emit(
                state.copyWith(
                  opponent: newOpponent,
                  combatState: CombatState.none,
                ),
              );
            }

          default:
            emit(state.copyWith(combatState: CombatState.none));
        }

      case LeaderCard():
        final Player newMe = state.me.copyWith(
          leaderCard: state.me.leaderCard.copyWith(
            isActive: false,
          ),
        );

        emit(
          state.copyWith(me: newMe, combatState: CombatState.countering),
        );

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
              final List<CharacterCard> newCharacterCards = [
                for (final character in state.opponent.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newOpponent = state.opponent.copyWith(
                characterCards: newCharacterCards,
              );

              emit(
                state.copyWith(
                  opponent: newOpponent,
                  combatState: CombatState.none,
                ),
              );
            }

          case LeaderCard():
            if (attackingCard.power >= targetCard.power + counterAmount) {
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

              emit(
                state.copyWith(
                  opponent: newOpponent,
                  combatState: CombatState.none,
                ),
              );
            }

          default:
            emit(state.copyWith(combatState: CombatState.none));
        }

      default:
        emit(state.copyWith(combatState: CombatState.none));
        return;
    }
  }
}
