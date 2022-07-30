import 'package:fish_redux/fish_redux.dart';

enum InviteFriendPageAction { action }

class InviteFriendPageActionCreator {
  static Action onAction() {
    return const Action(InviteFriendPageAction.action);
  }
}
