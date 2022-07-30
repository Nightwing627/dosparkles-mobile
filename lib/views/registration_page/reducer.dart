import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<RegistrationPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<RegistrationPageState>>{
      RegistrationPageAction.action: _onAction,
    },
  );
}

RegistrationPageState _onAction(RegistrationPageState state, Action action) {
  final RegistrationPageState newState = state.clone();
  return newState;
}
