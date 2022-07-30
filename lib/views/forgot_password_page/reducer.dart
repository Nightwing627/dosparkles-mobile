import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ForgotPasswordPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ForgotPasswordPageState>>{
      ForgotPasswordPageAction.action: _onAction,
    },
  );
}

ForgotPasswordPageState _onAction(
    ForgotPasswordPageState state, Action action) {
  final ForgotPasswordPageState newState = state.clone();
  return newState;
}
