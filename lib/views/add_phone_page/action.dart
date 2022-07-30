import 'package:fish_redux/fish_redux.dart';

enum AddPhonePageAction { action }

class AddPhonePageActionCreator {
  static Action onAction() {
    return const Action(AddPhonePageAction.action);
  }
}
