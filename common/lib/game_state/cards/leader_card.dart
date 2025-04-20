part of 'card.dart';

final class LeaderCard extends Card {
  const LeaderCard({
    required this.power,
    required this.attribute,
    required this.colors,
    required this.name,
    required this.life,
    required this.type,
    required this.blockNumber,
  });

  final int power;
  final CardAttribute attribute;
  final List<CardColor> colors;
  final String name;
  final int life;
  final String type;
  final int blockNumber;
}
