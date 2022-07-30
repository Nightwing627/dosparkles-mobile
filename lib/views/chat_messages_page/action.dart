import 'package:fish_redux/fish_redux.dart';

enum ChatMessagesPageAction { action, setIsFirst, onStart }

class ChatMessagesPageActionCreator {
  static Action onAction() {
    return const Action(ChatMessagesPageAction.action);
  }

  static Action onStart() {
    return const Action(ChatMessagesPageAction.onStart);
  }

  static Action setIsFirst(bool isFirst) {
    return Action(ChatMessagesPageAction.setIsFirst, payload: isFirst);
  }
}
