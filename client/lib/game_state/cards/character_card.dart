part of 'game_card.dart';

@immutable
abstract class CharacterCard extends DeckCard with DonAttachable {
  const CharacterCard({
    required super.id,
    required super.name,
    required super.type,
    required super.cost,
    required super.color,
    required super.cardNumber,
    required super.blockNumber,
    required this.basePower,
    required this.attributes,
    required this.isFrozen,
    required this.isActive,
    required this.counter,
    required this.attachedDonCards,
  });

  final int basePower;
  final List<CardAttribute> attributes;
  final int counter;
  final bool isFrozen;
  final bool isActive;
  @override
  final List<DonCard> attachedDonCards;

  int getEffectivePower({
    required bool isOnTurn,
    required int counterAmount,
    required CardLocation location,
  }) =>
      basePower +
      (isOnTurn ? 0 : counterAmount) +
      attachedDonCards.fold(0, (sum, don) => sum + (isOnTurn ? 1000 : 0));

  CharacterCard copyWith({
    String? name,
    String? type,
    int? cost,
    CardColor? color,
    String? cardNumber,
    int? blockNumber,
    int? basePower,
    List<CardAttribute>? attributes,
    bool? isFrozen,
    bool? isActive,
    int? counter,
    int? id,
    List<DonCard>? attachedDonCards,
  });
}
