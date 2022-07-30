import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ChatMessagesPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<ChatMessagesPageState>>{
      ChatMessagesPageAction.action: _onAction,
      ChatMessagesPageAction.setIsFirst: _setIsFirst,
    },
  );
}

ChatMessagesPageState _onAction(ChatMessagesPageState state, Action action) {
  final ChatMessagesPageState newState = state.clone();
  return newState;
}

ChatMessagesPageState _setIsFirst(ChatMessagesPageState state, Action action) {
  final bool _isFirst = action.payload;
  final ChatMessagesPageState newState = state.clone();
  newState.isFirstTime = _isFirst; //true;
  return newState;
}
