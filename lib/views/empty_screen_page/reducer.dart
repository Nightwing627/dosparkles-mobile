import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EmptyScreenPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<EmptyScreenPageState>>{
      EmptyScreenPageAction.action: _onAction,
    },
  );
}

EmptyScreenPageState _onAction(EmptyScreenPageState state, Action action) {
  final EmptyScreenPageState newState = state.clone();
  return newState;
}
