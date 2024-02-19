import '../../models/Wrapper.dart';

class InputPageDropdownState<T> {
  List<T>? choiceList;
  T? selectedChoice;
  int? loadingState;

  InputPageDropdownState({
    this.choiceList = const [],
    this.selectedChoice,
    this.loadingState = 0,
  });

  InputPageDropdownState<T> copy({
    List<T>? choiceList,
    T? selectedChoice, // Change the type from String? to T?
    int? loadingState,
  }) {
    return InputPageDropdownState<T>(
      choiceList: choiceList ?? this.choiceList,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}

class WrappedInputPageDropdownState<T> {
  Wrapper<List<T>>? choiceListWrapper;
  Wrapper<T>? selectedChoiceWrapper;
  Wrapper<int>? loadingStateWrapper;

  WrappedInputPageDropdownState({
    this.choiceListWrapper,
    this.selectedChoiceWrapper,
    this.loadingStateWrapper
  });

  WrappedInputPageDropdownState<T> copy({
    Wrapper<List<T>>? choiceListWrapper,
    Wrapper<T>? selectedChoiceWrapper,
    Wrapper<int>? loadingStateWrapper
  }) {
    return WrappedInputPageDropdownState(
      choiceListWrapper: choiceListWrapper ?? this.choiceListWrapper,
      selectedChoiceWrapper: selectedChoiceWrapper ?? this.selectedChoiceWrapper,
      loadingStateWrapper: loadingStateWrapper ?? this.loadingStateWrapper
    );
  }
}