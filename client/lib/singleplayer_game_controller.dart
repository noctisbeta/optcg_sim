import 'dart:async';

import 'package:client/combat_handler.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class SingleplayerGameController extends Cubit<GameState> {
  SingleplayerGameController() : super(GameState.empty()) {
    _combatHandler = CombatHandler(
      emit: emit,
      getState: () => state,
    );
    startGame();
  }

  late final CombatHandler _combatHandler;

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
    _refreshPhase();
    _drawPhase();
    _donPhase();
  }

  void _donPhase() {
    if (state.currentPlayer == state.me) {
      final Player newMe = state.me.copyWith(
        donCards: [
          ...state.me.donCards,
          if (state.me.donCards.length < GameState.maxDonCards)
            DonCard(
              id: state.me.donCards.length + 1,
              isActive: true,
              isFrozen: false,
            ),
          if (state.me.donCards.length + 1 < GameState.maxDonCards)
            DonCard(
              id: state.me.donCards.length + 1,
              isActive: true,
              isFrozen: false,
            ),
        ],
      );
      emit(state.copyWith(me: newMe));
    } else {
      final Player newOpponent = state.opponent.copyWith(
        donCards: [
          ...state.opponent.donCards,
          if (state.opponent.donCards.length < GameState.maxDonCards)
            DonCard(
              id: -state.opponent.donCards.length + 1,
              isActive: true,
              isFrozen: false,
            ),
          if (state.opponent.donCards.length + 1 < GameState.maxDonCards)
            DonCard(
              id: -state.opponent.donCards.length + 1,
              isActive: true,
              isFrozen: false,
            ),
        ],
      );
      emit(state.copyWith(opponent: newOpponent));
    }
  }

  void _drawPhase() {
    if (state.currentPlayer == state.me) {
      final Player newMe = state.me.copyWith(
        handCards: [
          ...state.me.handCards,
          state.me.deckCards.first,
        ],
        deckCards: state.me.deckCards.skip(1).toList(),
      );
      emit(state.copyWith(me: newMe));
    } else {
      final Player newOpponent = state.opponent.copyWith(
        handCards: [
          ...state.opponent.handCards,
          state.opponent.deckCards.first,
        ],
        deckCards: state.opponent.deckCards.skip(1).toList(),
      );
      emit(state.copyWith(opponent: newOpponent));
    }
  }

  void _refreshPhase() {
    if (state.currentPlayer == state.me) {
      final Player newMe = state.me.copyWith(
        donCards: _refreshDonCards(state.me.donCards),
        characterCards: _refreshCharacterCards(state.me.characterCards),
        leaderCard: _refreshLeaderCard(state.me.leaderCard),
        stageCard: state.me.stageCard?.copyWith(
          isActive: true,
        ),
      );
      emit(state.copyWith(me: newMe));
    } else {
      final Player newOpponent = state.opponent.copyWith(
        donCards: _refreshDonCards(state.opponent.donCards),
        characterCards: _refreshCharacterCards(state.opponent.characterCards),
        leaderCard: _refreshLeaderCard(state.opponent.leaderCard),
        stageCard: state.opponent.stageCard?.copyWith(
          isActive: true,
        ),
      );
      emit(state.copyWith(opponent: newOpponent));
    }
  }

  List<DonCard> _refreshDonCards(List<DonCard> donCards) => [
    for (final DonCard donCard in donCards)
      if (donCard.isFrozen)
        donCard.copyWith(isActive: false, isFrozen: false)
      else
        donCard.copyWith(isActive: true),
  ];

  List<CharacterCard> _refreshCharacterCards(
    List<CharacterCard> characterCards,
  ) => [
    for (final CharacterCard characterCard in characterCards)
      if (characterCard.isFrozen)
        characterCard.copyWith(isActive: false, isFrozen: false)
      else
        characterCard.copyWith(isActive: true),
  ];

  LeaderCard _refreshLeaderCard(LeaderCard leaderCard) {
    if (leaderCard.isFrozen) {
      return leaderCard.copyWith(isActive: false, isFrozen: false);
    }
    return leaderCard.copyWith(isActive: true);
  }
}
