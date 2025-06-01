part of 'card.dart';

final class DonCard extends Card {
  const DonCard({
    required super.id,
    required this.isActive,
    required this.isFrozen,
  });

  final bool isActive;

  final bool isFrozen;

  DonCard copyWith({
    bool? isActive,
    bool? isFrozen,
    int? id,
  }) => DonCard(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    isFrozen: isFrozen ?? this.isFrozen,
  );
}
