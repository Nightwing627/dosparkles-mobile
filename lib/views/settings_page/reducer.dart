import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SettingsPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<SettingsPageState>>{
      SettingsPageAction.action: _onAction,
    },
  );
}

SettingsPageState _onAction(SettingsPageState state, Action action) {
  final SettingsPageState newState = state.clone();
  return newState;
}
