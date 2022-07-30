import 'package:fish_redux/fish_redux.dart';

enum EmptyScreenPageAction {
  action,
}

class EmptyScreenPageActionCreator {
  static Action onAction() {
    return const Action(EmptyScreenPageAction.action);
  }
}
