import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:com.floridainc.dosparkles/models/models.dart';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'action.dart';
import 'state.dart';

Effect<StoreSelectionPageState> buildEffect() {
  return combineEffects(<Object, Effect<StoreSelectionPageState>>{
    StoreSelectionPageAction.action: _onAction,
    StoreSelectionPageAction.storeSelected: _onStoreSelected,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<StoreSelectionPageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));

  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;
  ctx.state.connectionStatus = GlobalStore.store.getState().connectionStatus;
}

void _onBuild(Action action, Context<StoreSelectionPageState> ctx) async {
  Future.delayed(Duration(milliseconds: 150),
      () => ctx.state.animationController.forward());
}

void _onDispose(Action action, Context<StoreSelectionPageState> ctx) {
  ctx.state.animationController.dispose();
}

void _onAction(Action action, Context<StoreSelectionPageState> ctx) {}

void _onStoreSelected(
    Action action, Context<StoreSelectionPageState> ctx) async {
  StoreItem store = action.payload;
  GlobalStore.store.dispatch(GlobalActionCreator.setSelectedStore(store));

  var meId = GlobalStore.store.getState().user.id;
  await BaseGraphQLClient.instance.setUsersFavoriteStore(meId, store.id);

  await Navigator.of(ctx.context).pushReplacementNamed('storepage');
}
