import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<StoreSelectionPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<StoreSelectionPageState>>{
      StoreSelectionPageAction.action: _onAction,
    },
  );
}

StoreSelectionPageState _onAction(StoreSelectionPageState state, Action action) {
  final StoreSelectionPageState newState = state.clone();
  return newState;
}