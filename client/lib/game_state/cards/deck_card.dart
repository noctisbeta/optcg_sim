part of 'card.dart';

sealed class DeckCard extends Card {
  const DeckCard({
    required this.name,
    required this.type,
    required this.cost,
    required this.color,
    required this.cardNumber,
    required this.blockNumber,
  });

  final String name;
  final String type;
  final int cost;
  final CardColor color;
  final String cardNumber;
  final int blockNumber;
}
