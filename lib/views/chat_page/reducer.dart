import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ChatPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ChatPageState>>{
      ChatPageAction.action: _onAction,
      ChatPageAction.setIsFirst: _setIsFirst,
    },
  );
}

ChatPageState _onAction(ChatPageState state, Action action) {
  final ChatPageState newState = state.clone();
  return newState;
}

ChatPageState _setIsFirst(ChatPageState state, Action action) {
  final bool _isFirst = action.payload;
  final ChatPageState newState = state.clone();
  newState.isFirstTime = _isFirst; //true;
  return newState;
}
