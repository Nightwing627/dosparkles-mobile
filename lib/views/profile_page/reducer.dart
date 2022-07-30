import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ProfilePageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ProfilePageState>>{
      ProfilePageAction.action: _onAction,
    },
  );
}

ProfilePageState _onAction(ProfilePageState state, Action action) {
  final ProfilePageState newState = state.clone();
  return newState;
}
