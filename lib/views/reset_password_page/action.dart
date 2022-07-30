import 'package:fish_redux/fish_redux.dart';

enum ResetPasswordPageAction { action }

class ResetPasswordPageActionCreator {
  static Action onAction() {
    return const Action(ResetPasswordPageAction.action);
  }
}
