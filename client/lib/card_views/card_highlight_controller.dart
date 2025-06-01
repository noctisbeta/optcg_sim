import 'package:client/game_state/cards/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardHighlightController extends Cubit<GameCard?> {
  CardHighlightController() : super(null);

  void highlightCard(GameCard? card) {
    emit(card);
  }

  void clearHighlight() {
    emit(null);
  }
}
