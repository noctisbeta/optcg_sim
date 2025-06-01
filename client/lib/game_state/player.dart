import 'package:client/card_implementations/op10/op10_005.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/properties/card_attribute.dart';
import 'package:client/game_state/cards/properties/card_color.dart';
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

  Player.empty()
    : name = 'Kekec Pašteta',
      lifeCards = const [],
      donCards = const [DonCard(id: 1, isActive: true, isFrozen: false)],
      stageCard = null,
      leaderCard = const LeaderCard(
        id: 1,
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

      deckCards =
          List.generate(
            20,
            (i) => OP10_005(
              id: i,
            ),
          )..insert(
            1,
            const CharacterCard(
              id: 2,
              name: 'Kekec',
              type: 'Warrior',
              cost: 2,
              color: CardColor.red,
              cardNumber: 'asd',
              blockNumber: 2,
              power: 4000,
              attributes: [CardAttribute.ranged],
              isFrozen: false,
              isActive: false,
              counter: 2000,
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
      leaderCard = const LeaderCard(
        id: 1,
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
      deckCards = List.generate(20, (i) => OP10_005(id: i)),
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
