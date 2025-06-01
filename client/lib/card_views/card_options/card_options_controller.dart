import 'package:client/card_views/card_options/card_options_state.dart';
import 'package:client/game_state/cards/card.dart';
import 'package:client/game_state/cards/card_location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOptionsController extends Cubit<CardOptionsState> {
  CardOptionsController()
    : super(
        const CardOptionsState(
          selectedCard: null,
          cardType: null,
          cardLocation: null,
        ),
      );

  void selectCard(
    GameCard card,
    CardLocation cardLocation,
  ) {
    emit(
      CardOptionsState(
        selectedCard: card,
        cardType: card.runtimeType,
        cardLocation: cardLocation,
      ),
    );
  }

  void clearSelection() {
    emit(
      const CardOptionsState(
        selectedCard: null,
        cardType: null,
        cardLocation: null,
      ),
    );
  }
}
