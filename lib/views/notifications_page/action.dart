import 'package:fish_redux/fish_redux.dart';

enum NotificationsPageAction { action }

class NotificationsPageActionCreator {
  static Action onAction() {
    return const Action(NotificationsPageAction.action);
  }
}
