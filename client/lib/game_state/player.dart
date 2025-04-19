import 'package:client/game_state/cards/card.dart';

final class Player {
  Player({
    required this.name,
    required this.lifeCards,
    required this.donCards,
    required this.stageCard,
    required this.leaderCard,
    required this.deckCards,
    required this.trashCards,
    required this.characterCards,
    required this.handCards,
  });

  final String name;
  final List<Card> lifeCards;
  final List<DonCard> donCards;
  final StageCard? stageCard;
  final LeaderCard? leaderCard;
  final List<Card> deckCards;
  final List<Card> trashCards;
  final List<CharacterCard> characterCards;
  final List<DeckCard> handCards;
}
