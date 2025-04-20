import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';

final class Player {
  const Player({
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

  const Player.empty()
    : name = 'Kekec Pašteta',
      lifeCards = const [],
      donCards = const [],
      stageCard = null,
      leaderCard = const LeaderCard(
        power: 5000,
        attribute: CardAttribute.slash,
        colors: [CardColor.blue, CardColor.red],
        name: 'Default Leader',
        life: 5,
        type: 'Warrior',
        blockNumber: 1,
      ),
      deckCards = const [],
      trashCards = const [],
      characterCards = const [],
      handCards = const [];

  final String name;
  final List<Card> lifeCards;
  final List<DonCard> donCards;
  final StageCard? stageCard;
  final LeaderCard leaderCard;
  final List<Card> deckCards;
  final List<Card> trashCards;
  final List<CharacterCard> characterCards;
  final List<DeckCard> handCards;
}
