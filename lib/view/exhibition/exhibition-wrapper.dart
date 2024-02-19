import 'exhibition-product-input-state.dart';

class ExhibitionWrapper{
  List<ExhibitionProgramInputState>? exhibitionProgramInputState;

  ExhibitionWrapper({
    this.exhibitionProgramInputState,
  });

  ExhibitionWrapper copy({
    List<ExhibitionProgramInputState>? exhibitionProgramInputState
  }) {
    return ExhibitionWrapper(
      exhibitionProgramInputState: exhibitionProgramInputState ?? this.exhibitionProgramInputState
    );
  }
}