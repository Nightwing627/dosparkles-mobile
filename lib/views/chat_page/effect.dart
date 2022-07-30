import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<ChatPageState> buildEffect() {
  return combineEffects(<Object, Effect<ChatPageState>>{
    ChatPageAction.action: _onAction,
    ChatPageAction.onStart: _onStart,
    Lifecycle.build: _onBuild,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<ChatPageState> ctx) {}
void _onInit(Action action, Context<ChatPageState> ctx) async {
  ctx.state.pageController = PageController();

  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;
  ctx.state.connectionStatus = GlobalStore.store.getState().connectionStatus;
}

void _onDispose(Action action, Context<ChatPageState> ctx) {
  ctx.state.pageController.dispose();
}

void _onBuild(Action action, Context<ChatPageState> ctx) {}

void _onStart(Action action, Context<ChatPageState> ctx) async {}
