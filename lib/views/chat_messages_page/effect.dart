import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Effect<ChatMessagesPageState> buildEffect() {
  return combineEffects(<Object, Effect<ChatMessagesPageState>>{
    ChatMessagesPageAction.action: _onAction,
    ChatMessagesPageAction.onStart: _onStart,
    Lifecycle.build: _onBuild,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<ChatMessagesPageState> ctx) {}
void _onInit(Action action, Context<ChatMessagesPageState> ctx) async {
  ctx.state.pageController = PageController();

  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;
  ctx.state.connectionStatus = GlobalStore.store.getState().connectionStatus;
}

void _onDispose(Action action, Context<ChatMessagesPageState> ctx) {
  ctx.state.pageController.dispose();
}

void _onBuild(Action action, Context<ChatMessagesPageState> ctx) {}
void _onStart(Action action, Context<ChatMessagesPageState> ctx) async {}
