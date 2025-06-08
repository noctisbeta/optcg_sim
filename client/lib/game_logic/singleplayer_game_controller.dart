import 'dart:async';

import 'package:client/game_logic/combat_handler.dart';
import 'package:client/game_logic/don_phase_controller.dart';
import 'package:client/game_logic/draw_phase_controller.dart';
import 'package:client/game_logic/refresh_phase_controller.dart';
import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class SingleplayerGameController extends Cubit<GameState> {
  SingleplayerGameController() : super(GameState.empty()) {
    _combatHandler = CombatHandler(
      emit: emit,
      getState: () => state,
    );

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

    startGame();
  }

  late final CombatHandler _combatHandler;
  late final RefreshPhaseController _refreshPhaseController;
  late final DrawPhaseController _drawPhaseController;
  late final DonPhaseController _donPhaseController;

  final List<DonCard> _selectedDonCards = [];

  int get counterAmount => _combatHandler.counterAmount;

  @override
  void emit(GameState state) {
    super.emit(state);

    if (state.me.deckCards.isEmpty) {
      emit(state.copyWith(winnerFn: () => state.opponent));
    } else if (state.opponent.deckCards.isEmpty) {
      emit(state.copyWith(winnerFn: () => state.me));
    }
  }

  void cancelAttack() {
    _combatHandler.cancelAttack();
  }

  void chooseAttackTarget(GameCard? card) {
    _combatHandler.chooseAttackTarget(card);
  }

  Future<void> attack(GameCard card) => _combatHandler.attack(card);

  void counter(DeckCard card, Player player) {
    _combatHandler.counter(card, player);
  }

  void resolveCounter() {
    _combatHandler.resolveCounter();
  }

  void attachDonCardToCharacter(
    CharacterCard characterCard,
  ) {
    if (_selectedDonCards.isEmpty) {
      return;
    }

    final CharacterCard newCharacter = characterCard.copyWith(
      attachedDonCards: [
        ...characterCard.attachedDonCards,
        ..._selectedDonCards,
      ],
    );

    final List<DonCard> newDonCards = List.from(
      state.currentPlayer.donCards,
    );

    for (final DonCard donCard in _selectedDonCards) {
      if (newDonCards.contains(donCard)) {
        newDonCards.remove(donCard);
      }
    }

    final Player newPlayer = state.currentPlayer.copyWith(
      donCards: newDonCards,
      characterCards: [
        for (final CharacterCard char in state.currentPlayer.characterCards)
          if (char != characterCard) char else newCharacter,
      ],
    );

    emit(
      state.copyWith(
        me: state.currentPlayer == state.me ? newPlayer : state.me,
        opponent: state.currentPlayer == state.opponent
            ? newPlayer
            : state.opponent,
        isAttachingDon: false,
      ),
    );

    cancelDonSelection();
  }

  void attachDonCardToLeader(LeaderCard leaderCard) {
    if (_selectedDonCards.isEmpty) {
      return;
    }

    final LeaderCard newLeader = state.currentPlayer.leaderCard.copyWith(
      attachedDonCards: [
        ...state.currentPlayer.leaderCard.attachedDonCards,
        ..._selectedDonCards,
      ],
    );

    final List<DonCard> newDonCards = List.from(
      state.currentPlayer.donCards,
    );

    for (final DonCard donCard in _selectedDonCards) {
      if (newDonCards.contains(donCard)) {
        newDonCards.remove(donCard);
      }
    }

    final Player newPlayer = state.currentPlayer.copyWith(
      donCards: newDonCards,
      leaderCard: newLeader,
    );

    emit(
      state.copyWith(
        me: state.currentPlayer == state.me ? newPlayer : state.me,
        opponent: state.currentPlayer == state.opponent
            ? newPlayer
            : state.opponent,
        isAttachingDon: false,
      ),
    );

    cancelDonSelection();
  }

  void selectDonCard(DonCard donCard) {
    if (_selectedDonCards.contains(donCard)) {
      _deselectDonCard(donCard);
    }

    _selectedDonCards.add(donCard);

    emit(
      state.copyWith(
        isAttachingDon: true,
      ),
    );
  }

  void _deselectDonCard(DonCard donCard) {
    _selectedDonCards.remove(donCard);

    if (_selectedDonCards.isEmpty) {
      emit(
        state.copyWith(
          isAttachingDon: false,
        ),
      );
    }
  }

  void cancelDonSelection() {
    _selectedDonCards.clear();

    emit(
      state.copyWith(
        isAttachingDon: false,
      ),
    );
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

  void playCard(DeckCard card) {
    if (state.currentPlayer == state.me) {
      _playCardMe(card);
    } else {
      _playCardOpponent(card);
    }
  }

  void _playCardOpponent(DeckCard card) {
    if (state.opponent.donCards.where((donCard) => donCard.isActive).length <
        card.cost) {
      return;
    }

    final newDonCards = <DonCard>[];

    int costCopy = card.cost;

    for (final DonCard donCard in state.opponent.donCards) {
      if (donCard.isActive && costCopy > 0) {
        newDonCards.add(donCard.copyWith(isActive: false));
        costCopy--;
      } else {
        newDonCards.add(donCard);
      }
    }

    final Player newOpponent = state.opponent.copyWith(
      handCards: [
        for (final DeckCard handCard in state.opponent.handCards)
          if (handCard != card) handCard,
      ],
      donCards: newDonCards,
      characterCards: [
        ...state.opponent.characterCards,
        card as CharacterCard,
      ],
    );

    emit(state.copyWith(opponent: newOpponent));
  }

  void _playCardMe(DeckCard card) {
    if (state.me.donCards.where((donCard) => donCard.isActive).length <
        card.cost) {
      return;
    }

    final newDonCards = <DonCard>[];

    int costCopy = card.cost;

    for (final DonCard donCard in state.me.donCards) {
      if (donCard.isActive && costCopy > 0) {
        newDonCards.add(donCard.copyWith(isActive: false));
        costCopy--;
      } else {
        newDonCards.add(donCard);
      }
    }

    final Player newMe = state.me.copyWith(
      handCards: [
        for (final DeckCard handCard in state.me.handCards)
          if (handCard != card) handCard,
      ],
      donCards: newDonCards,
      characterCards: [
        ...state.me.characterCards,
        card as CharacterCard,
      ],
    );

    emit(state.copyWith(me: newMe));
  }

  void passTurn() {
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
