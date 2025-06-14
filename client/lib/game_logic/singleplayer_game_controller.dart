import 'dart:async';

import 'package:client/game_logic/combat_controller.dart';
import 'package:client/game_logic/don_attach_controller.dart';
import 'package:client/game_logic/don_phase_controller.dart';
import 'package:client/game_logic/draw_phase_controller.dart';
import 'package:client/game_logic/effect_controller.dart';
import 'package:client/game_logic/end_phase_controller.dart';
import 'package:client/game_logic/refresh_phase_controller.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class SingleplayerGameController extends Cubit<GameState> {
  SingleplayerGameController() : super(GameState.empty()) {
    _refreshPhaseController = RefreshPhaseController(
      emit: emit,
      getState: () => state,
    );

    _drawPhaseController = DrawPhaseController(
      emit: emit,
      getState: () => state,
    );

    _donPhaseController = DonPhaseController(
      emit: emit,
      getState: () => state,
    );

    combatController = CombatController(
      emit: emit,
      getState: () => state,
    );

    donAttachController = DonAttachController(
      emit: emit,
      getState: () => state,
    );

    effectController = EffectController(
      emit: emit,
      getState: () => state,
    );

    endPhaseController = EndPhaseController(
      emit: emit,
      getState: () => state,
      effectController: effectController,
    );

    startGame();
  }

  late final CombatController combatController;
  late final RefreshPhaseController _refreshPhaseController;
  late final DrawPhaseController _drawPhaseController;
  late final DonPhaseController _donPhaseController;
  late final DonAttachController donAttachController;
  late final EndPhaseController endPhaseController;
  late final EffectController effectController;

  Completer<bool>? _confirmCompleter;

  @override
  void emit(GameState state) {
    super.emit(state);

    if (state.me.deckCards.isEmpty) {
      emit(state.copyWith(winnerFn: () => state.opponent));
    } else if (state.opponent.deckCards.isEmpty) {
      emit(state.copyWith(winnerFn: () => state.me));
    }
  }

  void startGame() {
    final myDeckCards = List<DeckCard>.from(state.me.deckCards)..shuffle();

    final List<DeckCard> firstHand = [];
    for (int i = 0; i < 5; i++) {
      if (myDeckCards.isNotEmpty) {
        firstHand.add(myDeckCards.removeAt(0));
      }
    }

    final List<DeckCard> lifeCards = [];
    for (int i = 0; i < 5; i++) {
      if (myDeckCards.isNotEmpty) {
        lifeCards.add(myDeckCards.removeAt(0));
      }
    }

    final Player newMe = state.me.copyWith(
      deckCards: myDeckCards,
      handCards: firstHand,
      lifeCards: lifeCards,
    );

    final oppoDeckCards = List<DeckCard>.from(state.opponent.deckCards)
      ..shuffle();

    final List<DeckCard> oppoFirstHand = [];
    for (int i = 0; i < 5; i++) {
      if (oppoDeckCards.isNotEmpty) {
        oppoFirstHand.add(oppoDeckCards.removeAt(0));
      }
    }

    final List<DeckCard> oppoLifeCards = [];
    for (int i = 0; i < 5; i++) {
      if (oppoDeckCards.isNotEmpty) {
        oppoLifeCards.add(oppoDeckCards.removeAt(0));
      }
    }

    final Player newOpponent = state.opponent.copyWith(
      deckCards: oppoDeckCards,
      handCards: oppoFirstHand,
      lifeCards: oppoLifeCards,
    );

    emit(state.copyWith(me: newMe, opponent: newOpponent));
  }

  Future<void> playCard(DeckCard card) async {
    if (state.currentPlayer.donCards
            .where((donCard) => donCard.isActive)
            .length <
        card.cost) {
      return;
    }

    final newDonCards = <DonCard>[];

    int costCopy = card.cost;

    for (final DonCard donCard in state.currentPlayer.donCards) {
      if (donCard.isActive && costCopy > 0) {
        newDonCards.add(donCard.copyWith(isActive: false));
        costCopy--;
      } else {
        newDonCards.add(donCard);
      }
    }

    final Player newPlayer = state.currentPlayer.copyWith(
      handCards: [
        for (final DeckCard handCard in state.currentPlayer.handCards)
          if (handCard != card) handCard,
      ],
      donCards: newDonCards,
      characterCards: [
        ...state.currentPlayer.characterCards,
        card as CharacterCard,
      ],
    );

    if (state.currentPlayer == state.me) {
      emit(state.copyWith(me: newPlayer));
    } else {
      emit(state.copyWith(opponent: newPlayer));
    }

    switch (card) {
      case OnPlay():
        card.onPlay(state: state, emit: emit, owner: newPlayer);
      case OptionalOnPlay():
        emit(
          state.copyWith(
            interactionState: ISconfirmingAction(
              interactingPlayer: state.currentPlayer,
            ),
          ),
        );

        _confirmCompleter = Completer<bool>();

        if (_confirmCompleter == null) {
          return;
        }

        final bool? decision = await _confirmCompleter?.future;

        emit(
          state.copyWith(
            interactionState: const ISnone(),
          ),
        );

        card.onPlay(
          state: state,
          emit: emit,
          owner: newPlayer,
          shouldActivate: decision ?? false,
        );
    }
  }

  void confirmAction() {
    if (_confirmCompleter != null) {
      _confirmCompleter!.complete(true);
      _confirmCompleter = null;
    }
  }

  void cancelAction() {
    if (_confirmCompleter != null) {
      _confirmCompleter!.complete(false);
      _confirmCompleter = null;
    }
  }

  Future<void> passTurn() async {
    await endPhaseController.endPhase();

    final GameState newState = state.copyWith(
      turn: state.turn + 1,
    );

    emit(newState);

    startTurn();
  }

  void startTurn() {
    _refreshPhaseController.refreshPhase();
    _drawPhaseController.drawPhase();
    _donPhaseController.donPhase();
  }
}
