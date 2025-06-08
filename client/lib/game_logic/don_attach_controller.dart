import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class DonAttachController {
  DonAttachController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();

  final List<DonCard> _selectedDonCards = [];

  void emit(GameState state) {
    _emit(state);
  }

  void attachDonCard(DonAttachable card) {
    if (_selectedDonCards.isEmpty) {
      return;
    }

    final List<DonCard> newDonCards = List.from(
      state.currentPlayer.donCards,
    );

    for (final DonCard don in _selectedDonCards) {
      if (newDonCards.contains(don)) {
        newDonCards.remove(don);
      }
    }

    if (card is LeaderCard) {
      final LeaderCard newLeader = state.currentPlayer.leaderCard.copyWith(
        attachedDonCards: List.from(_selectedDonCards),
      );

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
    } else if (card is CharacterCard) {
      final List<CharacterCard> newCharacterCards = List.from(
        state.currentPlayer.characterCards,
      );

      final int index = newCharacterCards.indexOf(card);

      if (index != -1) {
        final CharacterCard updatedCharacter = card.copyWith(
          attachedDonCards: List.from(_selectedDonCards),
        );
        newCharacterCards[index] = updatedCharacter;
      }

      final Player newPlayer = state.currentPlayer.copyWith(
        donCards: newDonCards,
        characterCards: newCharacterCards,
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
    }

    cancelDonSelection();
  }

  void selectDonCard(DonCard donCard) {
    if (_selectedDonCards.contains(donCard)) {
      deselectDonCard(donCard);
    }

    _selectedDonCards.add(donCard);

    emit(
      state.copyWith(
        isAttachingDon: true,
      ),
    );
  }

  void deselectDonCard(DonCard donCard) {
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
}
