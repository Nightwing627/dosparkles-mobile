import 'package:fish_redux/fish_redux.dart';

enum SettingsPageAction { action }

class SettingsPageActionCreator {
  static Action onAction() {
    return const Action(SettingsPageAction.action);
  }
}
