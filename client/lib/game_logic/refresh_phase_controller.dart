import 'package:client/game_state/cards/game_card.dart';
import 'package:client/game_state/game_state.dart';
import 'package:client/game_state/player.dart';

final class RefreshPhaseController {
  RefreshPhaseController({
    required void Function(GameState state) emit,
    required GameState Function() getState,
  }) : _emit = emit,
       _getState = getState;

  final void Function(GameState state) _emit;
  final GameState Function() _getState;

  GameState get state => _getState();

  void emit(GameState state) {
    _emit(state);
  }

  void refreshPhase() {
    final Player newPlayer = state.currentPlayer.copyWith(
      donCards: _refreshDonCards(state.currentPlayer.donCards),
      characterCards: _refreshCharacterCards(
        state.currentPlayer.characterCards,
      ),
      leaderCard: _refreshLeaderCard(state.currentPlayer.leaderCard),
      stageCard: state.currentPlayer.stageCard?.copyWith(
        isActive: true,
      ),
    );

    final Player newPlayerWithDetachedDon = _resetAttachedDonCards(newPlayer);

    if (state.currentPlayer == state.me) {
      emit(state.copyWith(me: newPlayerWithDetachedDon));
    } else {
      emit(state.copyWith(opponent: newPlayerWithDetachedDon));
    }
  }

  Player _resetAttachedDonCards(Player player) {
    final Player newPlayer = player.copyWith();

    final List<DonCard> resetDonFromLeader = _refreshAttachedDon(
      newPlayer.leaderCard,
    );

    final Player afterLeaderReset = newPlayer.copyWith(
      leaderCard: newPlayer.leaderCard.copyWith(
        attachedDonCards: [],
      ),
      donCards: [
        ...newPlayer.donCards,
        ...resetDonFromLeader,
      ],
    );

    final List<DonCard> resetDonFromCharacters = [];
    for (final CharacterCard character in afterLeaderReset.characterCards) {
      final List<DonCard> resetDonFromCharacter = _refreshAttachedDon(
        character,
      );

      resetDonFromCharacters.addAll(resetDonFromCharacter);
    }

    final Player afterCharactersReset = afterLeaderReset.copyWith(
      characterCards: [
        for (final CharacterCard character in afterLeaderReset.characterCards)
          character.copyWith(attachedDonCards: []),
      ],
      donCards: [
        ...afterLeaderReset.donCards,
        ...resetDonFromCharacters,
      ],
    );

    return afterCharactersReset;
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
    if (leaderCard.attachedDonCards.isNotEmpty) {}

    if (leaderCard.isFrozen) {
      return leaderCard.copyWith(isActive: false, isFrozen: false);
    }

    return leaderCard.copyWith(isActive: true);
  }

  List<DonCard> _refreshAttachedDon(DonAttachable card) {
    final List<DonCard> resetDonCards = [];

    for (final DonCard don in card.attachedDonCards) {
      final DonCard detatchedDon = don.copyWith(
        isActive: true,
        isFrozen: false,
      );

      resetDonCards.add(detatchedDon);
    }

    return resetDonCards;
  }
}
