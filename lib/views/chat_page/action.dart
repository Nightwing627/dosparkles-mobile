import 'package:fish_redux/fish_redux.dart';

enum ChatPageAction { action, setIsFirst, onStart }

class ChatPageActionCreator {
  static Action onAction() {
    return const Action(ChatPageAction.action);
  }

  static Action onStart() {
    return const Action(ChatPageAction.onStart);
  }

  static Action setIsFirst(bool isFirst) {
    return Action(ChatPageAction.setIsFirst, payload: isFirst);
  }
}
