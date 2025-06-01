import 'package:common/game_state/cards/card.dart';
import 'package:common/game_state/cards/properties/card_attribute.dart';
import 'package:common/game_state/cards/properties/card_color.dart';
import 'package:equatable/equatable.dart';

final class Player extends Equatable {
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
      donCards = const [DonCard(isActive: true, isFrozen: false)],
      stageCard = null,
      leaderCard = const LeaderCard(
        power: 5000,
        attribute: CardAttribute.slash,
        colors: [CardColor.blue, CardColor.red],
        name: 'Default Leader',
        life: 5,
        type: 'Warrior',
        blockNumber: 1,
        isActive: true,
        isFrozen: false,
      ),
      deckCards = const [
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.red,
          cardNumber: 'EB01-100',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.red,
          cardNumber: 'EB01-100',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.red,
          cardNumber: 'EB01-100',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.red,
          cardNumber: 'EB01-100',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.red,
          cardNumber: 'EB01-100',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
      ],
      trashCards = const [],
      characterCards = const [],
      handCards = const [];

  const Player.empty2()
    : name = 'Argeta Pašteta',
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
        isActive: true,
        isFrozen: false,
      ),
      deckCards = const [
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.blue,
          cardNumber: 'EB01-101',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.blue,
          cardNumber: 'EB01-101',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.blue,
          cardNumber: 'EB01-101',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.blue,
          cardNumber: 'EB01-101',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
        CharacterCard(
          name: 'Default Character',
          type: 'Pirate',
          cost: 2,
          color: CardColor.blue,
          cardNumber: 'EB01-101',
          blockNumber: 1,
          power: 3000,
          attributes: [],
          isFrozen: false,
          isActive: true,
        ),
      ],
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
  );

  @override
  List<Object?> get props => [
    name,
    lifeCards,
    donCards,
    stageCard,
    leaderCard,
    deckCards,
    trashCards,
    characterCards,
    handCards,
  ];
}
