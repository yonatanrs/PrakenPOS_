import 'exhibition-product-input-state.dart';

class InputPageWrapper {
  List<ExhibitionProgramInputState>? exhibitionProgramInputState;
  bool? isAddItem;

  InputPageWrapper({
    this.exhibitionProgramInputState,
    this.isAddItem
  });

  InputPageWrapper copy({
    List<ExhibitionProgramInputState>? exhibitionProgramInputState,
    bool? isAddItem
  }) {
    return InputPageWrapper(
      exhibitionProgramInputState: exhibitionProgramInputState ?? this.exhibitionProgramInputState,
      isAddItem: isAddItem ?? this.isAddItem
    );
  }
}