import 'package:client/game_state/cards/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsController extends Cubit<DeckCard?> {
  CardOptionsController() : super(null);

  void selectCard(DeckCard? card) {
    emit(card);
  }

  void clearSelection() {
    emit(null);
  }
}
