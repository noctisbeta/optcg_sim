import 'package:client/game_state/player.dart';
import 'package:flutter/foundation.dart' show immutable;

enum InteractionState2 { none, choosingAttackTarget }

@immutable
sealed class InteractionState {
  const InteractionState();
}

@immutable
final class ISnone extends InteractionState {
  const ISnone();
}

@immutable
final class ISchoosingAttackTarget extends InteractionState {
  const ISchoosingAttackTarget({
    required this.interactingPlayer,
  });

  final Player interactingPlayer;
}

@immutable
final class IScountering extends InteractionState {
  const IScountering({
    required this.interactingPlayer,
  });

  final Player interactingPlayer;
}

@immutable
final class ISattachingDon extends InteractionState {
  const ISattachingDon({
    required this.interactingPlayer,
  });

  final Player interactingPlayer;
}

@immutable
final class ISconfirmingAction extends InteractionState {
  const ISconfirmingAction({
    required this.interactingPlayer,
  });

  final Player interactingPlayer;
}

@immutable
final class ISselectingCardInHand extends InteractionState {
  const ISselectingCardInHand({
    required this.interactingPlayer,
  });

  final Player interactingPlayer;
}
