import 'package:fish_redux/fish_redux.dart';

enum RegistrationPageAction { action }

class RegistrationPageActionCreator {
  static Action onAction() {
    return const Action(RegistrationPageAction.action);
  }
}
