import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/interaction_state.dart';
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

  bool isDonCardSelected(DonCard donCard) =>
      _selectedDonCards.contains(donCard);

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

      _emit(
        state.copyWith(
          me: state.currentPlayer == state.me ? newPlayer : state.me,
          opponent: state.currentPlayer == state.opponent
              ? newPlayer
              : state.opponent,
          isAttachingDon: false,
          interactionState: const ISnone(),
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

      _emit(
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

  void toggleDonCardSelection(DonCard donCard) {
    if (_selectedDonCards.contains(donCard)) {
      _selectedDonCards.remove(donCard);
    } else {
      _selectedDonCards.add(donCard);
    }

    _emit(
      state.copyWith(
        isAttachingDon: _selectedDonCards.isNotEmpty,
        interactionState: _selectedDonCards.isNotEmpty
            ? ISattachingDon(interactingPlayer: state.currentPlayer)
            : const ISnone(),
      ),
    );
  }

  void cancelDonSelection() {
    _selectedDonCards.clear();

    _emit(
      state.copyWith(
        isAttachingDon: false,
        interactionState: const ISnone(),
      ),
    );
  }
}
