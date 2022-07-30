import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AddPhonePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<AddPhonePageState>>{
      AddPhonePageAction.action: _onAction,
    },
  );
}

AddPhonePageState _onAction(AddPhonePageState state, Action action) {
  final AddPhonePageState newState = state.clone();
  return newState;
}
