import 'dart:async';

import 'package:client/game_state/cards/card_location.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/combat_state.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';

final class CombatController {
  CombatController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  Completer<GameCard?>? _targetCompleter;
  Completer<int?>? _counterCompleter;
  int _counterAmount = 0;
  GameCard? _targetCard;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();

  void emit(GameState state) {
    _emit(state);
  }

  int getCounterAmountFor(GameCard card) {
    if (_targetCard == null) {
      return 0;
    } else if (_targetCard == card) {
      return _counterAmount;
    }
    return 0;
  }

  void cancelAttack() {
    _targetCompleter?.complete(null);
    _targetCompleter = null;
    _targetCard = null;
  }

  void chooseAttackTarget(GameCard? card) {
    if (card == null) {
      _targetCompleter?.complete(null);
      _targetCompleter = null;

      return;
    }
    _targetCard = card;
    _targetCompleter?.complete(card);
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

    await _generalAttack(card);
  }

  Future<void> _generalAttack(GameCard attackingCard) async {
    final GameState attackingState = state.copyWith(
      combatState: CombatState.attacking,
      interactionState: ISchoosingAttackTarget(
        interactingPlayer: state.currentPlayer,
      ),
    );

    final Player attackingPlayer = state.currentPlayer;
    final Player defendingPlayer = attackingPlayer == state.me
        ? state.opponent
        : state.me;

    final bool isMeAttacking = attackingPlayer == state.me;

    emit(attackingState);

    _targetCompleter = Completer<GameCard?>();

    final GameCard? targetCard = await _targetCompleter?.future;

    emit(
      state.copyWith(
        combatState: CombatState.countering,
        interactionState: IScountering(interactingPlayer: defendingPlayer),
      ),
    );

    _counterCompleter = Completer<int?>();

    switch (attackingCard) {
      case CharacterCard():
        final List<CharacterCard> newCharacterCards = [
          for (final character in attackingPlayer.characterCards)
            if (character == attackingCard)
              character.copyWith(isActive: false)
            else
              character,
        ];

        final Player newAttackingPlayer = attackingPlayer.copyWith(
          characterCards: newCharacterCards,
        );

        emit(
          state.copyWith(
            me: isMeAttacking ? newAttackingPlayer : state.me,
            opponent: state.opponent,
            combatState: CombatState.countering,
          ),
        );

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
            interactionState: const ISnone(),
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.getEffectivePower(
                  isOnTurn: true,
                  counterAmount: 0,
                  location: CardLocation.characterArea,
                ) >=
                targetCard.getEffectivePower(
                      isOnTurn: false,
                      counterAmount: 0,
                      location: CardLocation.characterArea,
                    ) +
                    counterAmount) {
              final List<DeckCard> newDefendingPlayerTrashCards = [
                ...defendingPlayer.trashCards,
                targetCard,
              ];

              final List<CharacterCard> newCharacterCards = [
                for (final character in defendingPlayer.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newDefendingPlayer = defendingPlayer.copyWith(
                characterCards: newCharacterCards,
                trashCards: newDefendingPlayerTrashCards,
              );

              emit(
                state.copyWith(
                  opponent: newDefendingPlayer,
                  combatState: CombatState.none,
                  interactionState: const ISnone(),
                ),
              );

              if (targetCard is EffectOnKO) {
                targetCard.onKO(
                  state,
                  emit,
                  isMeAttacking ? state.opponent : state.me,
                );
              }
            }

          case LeaderCard():
            if (attackingCard.getEffectivePower(
                  isOnTurn: true,
                  counterAmount: 0,
                  location: CardLocation.characterArea,
                ) >=
                targetCard.getEffectivePower(
                      isOnTurn: false,
                      counterAmount: 0,
                    ) +
                    counterAmount) {
              final List<DeckCard> defendingPlayerLifeCards = List.from(
                defendingPlayer.lifeCards,
              );

              final DeckCard takenLife = defendingPlayerLifeCards.removeAt(0);

              final List<DeckCard> newDefendingPlayerHandCards = [
                ...defendingPlayer.handCards,
                takenLife,
              ];

              final Player newDefendingPlayer = defendingPlayer.copyWith(
                lifeCards: defendingPlayerLifeCards,
                handCards: newDefendingPlayerHandCards,
              );

              emit(
                state.copyWith(
                  me: isMeAttacking ? newAttackingPlayer : newDefendingPlayer,
                  opponent: isMeAttacking
                      ? newDefendingPlayer
                      : newAttackingPlayer,
                  combatState: CombatState.none,
                  interactionState: const ISnone(),
                ),
              );
            }

          default:
            emit(
              state.copyWith(
                combatState: CombatState.none,
                interactionState: const ISnone(),
              ),
            );
        }

      case LeaderCard():
        final Player newAttackingPlayer = attackingPlayer.copyWith(
          leaderCard: attackingPlayer.leaderCard.copyWith(
            isActive: false,
          ),
        );

        emit(
          state.copyWith(
            me: isMeAttacking ? newAttackingPlayer : state.me,
            opponent: isMeAttacking ? state.opponent : newAttackingPlayer,
            combatState: CombatState.countering,
          ),
        );

        final int counterAmount = await _counterCompleter?.future ?? 0;

        emit(
          state.copyWith(
            combatState: CombatState.none,
            interactionState: const ISnone(),
          ),
        );

        switch (targetCard) {
          case CharacterCard():
            if (attackingCard.getEffectivePower(
                  isOnTurn: true,
                  counterAmount: 0,
                ) >=
                targetCard.getEffectivePower(
                      isOnTurn: false,
                      counterAmount: 0,
                      location: CardLocation.characterArea,
                    ) +
                    counterAmount) {
              final List<DeckCard> newDefendingPlayerTrashCards = [
                ...defendingPlayer.trashCards,
                targetCard,
              ];

              final List<CharacterCard> newCharacterCards = [
                for (final character in defendingPlayer.characterCards)
                  if (character != targetCard) character,
              ];

              final Player newDefendingPlayer = defendingPlayer.copyWith(
                characterCards: newCharacterCards,
                trashCards: newDefendingPlayerTrashCards,
              );

              emit(
                state.copyWith(
                  me: isMeAttacking ? newAttackingPlayer : newDefendingPlayer,
                  opponent: isMeAttacking
                      ? newDefendingPlayer
                      : newAttackingPlayer,
                  combatState: CombatState.none,
                  interactionState: const ISnone(),
                ),
              );

              if (targetCard is EffectOnKO) {
                targetCard.onKO(
                  state,
                  emit,
                  isMeAttacking ? state.opponent : state.me,
                );
              }
            }

          case LeaderCard():
            if (attackingCard.getEffectivePower(
                  isOnTurn: true,
                  counterAmount: 0,
                ) >=
                targetCard.getEffectivePower(
                      isOnTurn: false,
                      counterAmount: 0,
                    ) +
                    counterAmount) {
              final List<DeckCard> defendingPlayerLifeCards = List.from(
                defendingPlayer.lifeCards,
              );

              final DeckCard takenLife = defendingPlayerLifeCards.removeAt(0);

              final List<DeckCard> newDefendingPlayerHandCards = [
                ...defendingPlayer.handCards,
                takenLife,
              ];

              final Player newDefendingPlayer = defendingPlayer.copyWith(
                lifeCards: defendingPlayerLifeCards,
                handCards: newDefendingPlayerHandCards,
              );

              emit(
                state.copyWith(
                  me: isMeAttacking ? newAttackingPlayer : newDefendingPlayer,
                  opponent: isMeAttacking
                      ? newDefendingPlayer
                      : newAttackingPlayer,
                  combatState: CombatState.none,
                  interactionState: const ISnone(),
                ),
              );
            }

          default:
            emit(
              state.copyWith(
                combatState: CombatState.none,
                interactionState: const ISnone(),
              ),
            );
        }

      default:
        emit(
          state.copyWith(
            combatState: CombatState.none,
            interactionState: const ISnone(),
          ),
        );
        return;
    }
  }
}
