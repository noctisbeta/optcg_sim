part of 'card.dart';

final class CharacterCard extends DeckCard {
  const CharacterCard({
    required super.name,
    required super.type,
    required super.cost,
    required super.color,
    required super.cardNumber,
    required super.blockNumber,
    required this.power,
    required this.attributes,
    this.counter,
  });

  final int power;
  final List<CardAttribute> attributes;
  final int? counter;
}
