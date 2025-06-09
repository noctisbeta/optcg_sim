import 'dart:async';

import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';

final class EffectController {
  EffectController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();

  Completer<GameCard?>? _cardCompleter;

  void emit(GameState state) {
    _emit(state);
  }

  void selectCardInHand(Player player, DeckCard card) {
    _cardCompleter!.complete(card);
  }

  Future<void> trashFromHand(Player player, void Function() onComplete) async {
    _cardCompleter = Completer<GameCard?>();

    emit(
      state.copyWith(
        interactionState: ISselectingCardInHand(interactingPlayer: player),
      ),
    );

    final GameCard? selectedCard = await _cardCompleter?.future;
    _cardCompleter = null;

    if (selectedCard == null) {
      return;
    }

    if (selectedCard is! DeckCard) {
      return;
    }

    final newHandCards = List<DeckCard>.from(player.handCards)
      ..remove(selectedCard);

    final newTrashCards = List<DeckCard>.from(player.trashCards)
      ..add(selectedCard);

    final Player newPlayer = player.copyWith(
      handCards: newHandCards,
      trashCards: newTrashCards,
    );

    if (player == state.me) {
      emit(state.copyWith(me: newPlayer));
    } else {
      emit(state.copyWith(opponent: newPlayer));
    }

    onComplete();
  }
}
