import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';

import 'action.dart';
import 'state.dart';

Effect<SettingsPageState> buildEffect() {
  return combineEffects(<Object, Effect<SettingsPageState>>{
    SettingsPageAction.action: _onAction,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<SettingsPageState> ctx) async {
  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;
  ctx.state.connectionStatus = GlobalStore.store.getState().connectionStatus;
}

void _onBuild(Action action, Context<SettingsPageState> ctx) {}

void _onDispose(Action action, Context<SettingsPageState> ctx) {}

void _onAction(Action action, Context<SettingsPageState> ctx) {}
