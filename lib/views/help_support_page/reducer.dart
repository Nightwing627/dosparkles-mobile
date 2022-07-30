import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HelpSupportPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<HelpSupportPageState>>{
      HelpSupportPageAction.action: _onAction,
    },
  );
}

HelpSupportPageState _onAction(HelpSupportPageState state, Action action) {
  final HelpSupportPageState newState = state.clone();
  return newState;
}
