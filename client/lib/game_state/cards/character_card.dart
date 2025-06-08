part of 'game_card.dart';

@immutable
class CharacterCard extends DeckCard with DonAttachable {
  const CharacterCard({
    required super.id,
    required super.name,
    required super.type,
    required super.cost,
    required super.color,
    required super.cardNumber,
    required super.blockNumber,
    required this.power,
    required this.attributes,
    required this.isFrozen,
    required this.isActive,
    required this.counter,
    required this.attachedDonCards,
  });

  final int power;
  final List<CardAttribute> attributes;
  final int counter;
  final bool isFrozen;
  final bool isActive;
  @override
  final List<DonCard> attachedDonCards;

  CharacterCard copyWith({
    String? name,
    String? type,
    int? cost,
    CardColor? color,
    String? cardNumber,
    int? blockNumber,
    int? power,
    List<CardAttribute>? attributes,
    bool? isFrozen,
    bool? isActive,
    int? counter,
    int? id,
    List<DonCard>? attachedDonCards,
  }) => CharacterCard(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    cost: cost ?? this.cost,
    color: color ?? this.color,
    cardNumber: cardNumber ?? this.cardNumber,
    blockNumber: blockNumber ?? this.blockNumber,
    power: power ?? this.power,
    attributes: attributes ?? this.attributes,
    isFrozen: isFrozen ?? this.isFrozen,
    isActive: isActive ?? this.isActive,
    counter: counter ?? this.counter,
    attachedDonCards: attachedDonCards ?? this.attachedDonCards,
  );
}
