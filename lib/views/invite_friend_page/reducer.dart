import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<InviteFriendPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<InviteFriendPageState>>{
      InviteFriendPageAction.action: _onAction,
    },
  );
}

InviteFriendPageState _onAction(InviteFriendPageState state, Action action) {
  final InviteFriendPageState newState = state.clone();
  return newState;
}
