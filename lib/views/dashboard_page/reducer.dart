import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<DashboardPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<DashboardPageState>>{
      DashboardPageAction.action: _onAction,
    },
  );
}

DashboardPageState _onAction(DashboardPageState state, Action action) {
  final DashboardPageState newState = state.clone();
  return newState;
}
