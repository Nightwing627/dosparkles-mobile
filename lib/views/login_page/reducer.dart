import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<LoginPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<LoginPageState>>{
      LoginPageAction.action: _onAction,
      LoginPageAction.setIsLoading: _onSetIsLoading,
    },
  );
}

LoginPageState _onAction(LoginPageState state, Action action) {
  final LoginPageState newState = state.clone();
  return newState;
}

LoginPageState _onSetIsLoading(LoginPageState state, Action action) {
  final LoginPageState newState = state.clone();
  newState.isLoading = action.payload;
  return newState;
}
