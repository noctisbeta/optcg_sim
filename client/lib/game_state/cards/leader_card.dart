part of 'card.dart';

final class LeaderCard extends GameCard {
  const LeaderCard({
    required super.id,
    required this.power,
    required this.attribute,
    required this.colors,
    required this.name,
    required this.life,
    required this.type,
    required this.blockNumber,
    required this.isActive,
    required this.isFrozen,
    required this.attachedDonCards,
  });

  final int power;
  final CardAttribute attribute;
  final List<CardColor> colors;
  final String name;
  final int life;
  final String type;
  final int blockNumber;
  final bool isActive;
  final bool isFrozen;
  final List<DonCard> attachedDonCards;

  LeaderCard copyWith({
    int? power,
    CardAttribute? attribute,
    List<CardColor>? colors,
    String? name,
    int? life,
    String? type,
    int? blockNumber,
    bool? isActive,
    bool? isFrozen,
    int? id,
    List<DonCard>? attachedDonCards,
  }) => LeaderCard(
    id: id ?? this.id,
    power: power ?? this.power,
    attribute: attribute ?? this.attribute,
    colors: colors ?? this.colors,
    name: name ?? this.name,
    life: life ?? this.life,
    type: type ?? this.type,
    blockNumber: blockNumber ?? this.blockNumber,
    isActive: isActive ?? this.isActive,
    isFrozen: isFrozen ?? this.isFrozen,
    attachedDonCards: attachedDonCards ?? this.attachedDonCards,
  );
}
