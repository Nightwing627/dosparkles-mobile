import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UploadVideoState> buildReducer() {
  return asReducer(
    <Object, Reducer<UploadVideoState>>{
      UploadVideoAction.action: _onAction,
    },
  );
}

UploadVideoState _onAction(UploadVideoState state, Action action) {
  final UploadVideoState newState = state.clone();
  return newState;
}
