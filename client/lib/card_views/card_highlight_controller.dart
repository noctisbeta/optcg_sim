import 'package:client/game_state/cards/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardHighlightController extends Cubit<DeckCard?> {
  CardHighlightController() : super(null);

  void highlightCard(DeckCard? card) {
    emit(card);
  }

  void clearHighlight() {
    emit(null);
  }
}
