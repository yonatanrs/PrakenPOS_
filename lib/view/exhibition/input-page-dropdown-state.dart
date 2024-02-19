import 'Wrapper.dart';

class InputPageDropdownState<T> {
  List<T>? choiceList;
  T? selectedChoice;
  int? loadingState;

  InputPageDropdownState({
    this.choiceList = const [],
    this.selectedChoice,
    this.loadingState = 0
  });

  InputPageDropdownState<T> copy({
    List<T>? choiceList,
    T? selectedChoice,
    int? loadingState
  }) {
    return InputPageDropdownState(
      choiceList: choiceList ?? this.choiceList,
      selectedChoice: selectedChoice ?? this.selectedChoice,
      loadingState: loadingState ?? this.loadingState
    );
  }
}

class WrappedInputPageDropdownState<T> extends InputPageDropdownState<T> {
  Wrapper<List<T>>? choiceListWrapper;
  Wrapper<T>? selectedChoiceWrapper;
  Wrapper<int>? loadingStateWrapper;

  @override
  List<T> get choiceList => choiceListWrapper!.value!;
  @override
  T get selectedChoice => selectedChoiceWrapper!.value!;
  @override
  int get loadingState => loadingStateWrapper!.value!;

  @override
  set choiceList(List<T>? value) => choiceListWrapper!.value = value;
  @override
  set selectedChoice(T? value) => selectedChoiceWrapper!.value = value;
  @override
  set loadingState(int? value) => loadingStateWrapper!.value = value;

  WrappedInputPageDropdownState({
    this.choiceListWrapper,
    this.selectedChoiceWrapper,
    this.loadingStateWrapper
  });

  WrappedInputPageDropdownState<T> copyWrapped({
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

  @override
  WrappedInputPageDropdownState<T> copy({
    List<T>? choiceList,
    T? selectedChoice,
    int? loadingState
  }) {
    return WrappedInputPageDropdownState(
      choiceListWrapper: Wrapper<List<T>>(value: choiceList),
      selectedChoiceWrapper: Wrapper<T>(value: selectedChoice),
      loadingStateWrapper: Wrapper<int>(value: loadingState)
    );
  }
}