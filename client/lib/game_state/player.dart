import 'package:client/card_implementations/op10/op10_005.dart';
import 'package:client/card_implementations/op10/op10_112.dart';
import 'package:client/game_state/cards/game_card.dart';
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
    required this.isOpponent,
  });

  Player.empty()
    : name = 'Kekec Pašteta',
      lifeCards = const [],
      donCards = const [DonCard(id: 1, isActive: true, isFrozen: false)],
      stageCard = null,
      isOpponent = false,
      leaderCard = const LeaderCard(
        id: 1,
        basePower: 5000,
        attribute: CardAttribute.slash,
        colors: [CardColor.blue, CardColor.red],
        name: 'Default Leader',
        life: 5,
        type: 'Warrior',
        blockNumber: 1,
        isActive: true,
        isFrozen: false,
        attachedDonCards: [],
      ),
      deckCards = List.generate(
        20,
        (i) => OP10_005(
          id: i,
          isActive: true,
          isFrozen: false,
          attachedDonCards: const [],
        ),
      ),
      trashCards = const [],
      characterCards = const [],
      handCards = const [];

  Player.empty2()
    : name = 'Argeta Pašteta',
      lifeCards = const [],
      donCards = const [],
      stageCard = null,
      isOpponent = true,
      leaderCard = const LeaderCard(
        id: 1,
        basePower: 5000,
        attribute: CardAttribute.slash,
        colors: [CardColor.blue, CardColor.red],
        name: 'Default Leader',
        life: 5,
        type: 'Warrior',
        blockNumber: 1,
        isActive: true,
        isFrozen: false,
        attachedDonCards: [],
      ),
      deckCards = List.generate(
        20,
        (i) => OP10_112(
          id: i,
          isActive: true,
          isFrozen: false,
          attachedDonCards: const [],
        ),
      ),
      trashCards = const [],
      characterCards = const [],
      handCards = const [];

  final String name;
  final List<DeckCard> lifeCards;
  final List<DonCard> donCards;
  final StageCard? stageCard;
  final LeaderCard leaderCard;
  final List<DeckCard> deckCards;
  final List<DeckCard> trashCards;
  final List<CharacterCard> characterCards;
  final List<DeckCard> handCards;
  final bool isOpponent;

  Player copyWith({
    String? name,
    List<DeckCard>? lifeCards,
    List<DonCard>? donCards,
    StageCard? stageCard,
    LeaderCard? leaderCard,
    List<DeckCard>? deckCards,
    List<DeckCard>? trashCards,
    List<CharacterCard>? characterCards,
    List<DeckCard>? handCards,
    bool? isOpponent,
  }) => Player(
    name: name ?? this.name,
    lifeCards: lifeCards ?? this.lifeCards,
    donCards: donCards ?? this.donCards,
    stageCard: stageCard ?? this.stageCard,
    leaderCard: leaderCard ?? this.leaderCard,
    deckCards: deckCards ?? this.deckCards,
    trashCards: trashCards ?? this.trashCards,
    characterCards: characterCards ?? this.characterCards,
    handCards: handCards ?? this.handCards,
    isOpponent: isOpponent ?? this.isOpponent,
  );
}
