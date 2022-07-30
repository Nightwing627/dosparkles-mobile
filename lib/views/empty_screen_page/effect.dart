import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<EmptyScreenPageState> buildEffect() {
  return combineEffects(<Object, Effect<EmptyScreenPageState>>{
    EmptyScreenPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<EmptyScreenPageState> ctx) async {}

void _onBuild(Action action, Context<EmptyScreenPageState> ctx) {}

void _onDispose(Action action, Context<EmptyScreenPageState> ctx) {}

void _onAction(Action action, Context<EmptyScreenPageState> ctx) {}
