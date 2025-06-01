part of 'card.dart';

final class StageCard extends DeckCard {
  StageCard({
    required super.name,
    required super.type,
    required super.cost,
    required super.color,
    required super.cardNumber,
    required super.blockNumber,
    required this.isActive,
  });

  final bool isActive;

  StageCard copyWith({
    String? name,
    String? type,
    int? cost,
    CardColor? color,
    String? cardNumber,
    int? blockNumber,
    bool? isActive,
  }) => StageCard(
    name: name ?? this.name,
    type: type ?? this.type,
    cost: cost ?? this.cost,
    color: color ?? this.color,
    cardNumber: cardNumber ?? this.cardNumber,
    blockNumber: blockNumber ?? this.blockNumber,
    isActive: isActive ?? this.isActive,
  );
}
