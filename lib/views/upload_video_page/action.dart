import 'package:fish_redux/fish_redux.dart';

enum UploadVideoAction { action }

class UploadVideoActionCreator {
  static Action onAction() {
    return const Action(UploadVideoAction.action);
  }
}
