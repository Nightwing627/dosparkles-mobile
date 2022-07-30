import 'package:fish_redux/fish_redux.dart';
import 'state.dart';
import 'action.dart';

Reducer<CustomizeLinkPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<CustomizeLinkPageState>>{
      CustomizeLinkPageAction.action: _onAction,
    },
  );
}

CustomizeLinkPageState _onAction(CustomizeLinkPageState state, Action action) {
  final CustomizeLinkPageState newState = state.clone();
  return newState;
}
