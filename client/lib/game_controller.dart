import 'package:common/game_state/cards/card.dart';
import 'package:common/game_state/game_state.dart';
import 'package:common/game_state/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class GameController extends Cubit<GameState> {
  GameController() : super(const GameState.empty());

  @override
  void emit(GameState state) {
    super.emit(state);

    if (state.me.deckCards.isEmpty) {
      emit(state.copyWith(winner: state.opponent));
    } else if (state.opponent.deckCards.isEmpty) {
      emit(state.copyWith(winner: state.me));
    }
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
            const DonCard(isActive: true, isFrozen: false),
          if (state.me.donCards.length + 1 < GameState.maxDonCards)
            const DonCard(isActive: true, isFrozen: false),
        ],
      );
      emit(state.copyWith(me: newMe));
    } else {
      final Player newOpponent = state.opponent.copyWith(
        donCards: [
          ...state.opponent.donCards,
          if (state.opponent.donCards.length < GameState.maxDonCards)
            const DonCard(isActive: true, isFrozen: false),
          if (state.opponent.donCards.length + 1 < GameState.maxDonCards)
            const DonCard(isActive: true, isFrozen: false),
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
