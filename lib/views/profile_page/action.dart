import 'package:fish_redux/fish_redux.dart';

enum ProfilePageAction { action }

class ProfilePageActionCreator {
  static Action onAction() {
    return const Action(ProfilePageAction.action);
  }
}
