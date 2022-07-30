import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'action.dart';
import 'state.dart';

Effect<StorePageState> buildEffect() {
  return combineEffects(<Object, Effect<StorePageState>>{
    StorePageAction.action: _onAction,
    StorePageAction.goToProductPage: onGoToProductPage,
    StorePageAction.goToCart: _onGoToCart,
    StorePageAction.addToCart: _onAddToCart,
    StorePageAction.backToProduct: _onBackToProduct,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<StorePageState> ctx) async {
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

  if (ctx.state.productIndex == null) {
    if (ctx.state.selectedStore != null && ctx.state.selectedProduct != null) {
      for (var i = 0; i < ctx.state.selectedStore.products.length; i++) {
        if (ctx.state.selectedStore.products[i].id ==
            ctx.state.selectedProduct.id) {
          ctx.state.productIndex = i;
          break;
        }
      }
    } else {
      ctx.state.listView = true;
    }
  }
}

void _onBuild(Action action, Context<StorePageState> ctx) {
  if (ctx.state.animationController != null) {
    Future.delayed(Duration(milliseconds: 150),
        () => ctx.state.animationController.forward());
  }
}

void _onDispose(Action action, Context<StorePageState> ctx) {
  ctx.state.animationController.dispose();
}

void _onAction(Action action, Context<StorePageState> ctx) {}

void onGoToProductPage(Action action, Context<StorePageState> ctx) async {
  ProductItem product = action.payload;

  GlobalStore.store.dispatch(GlobalActionCreator.setSelectedProduct(product));

  await Navigator.of(ctx.context).pushReplacementNamed('productpage');
}

void _onGoToCart(Action action, Context<StorePageState> ctx) async {
  if (ctx.state.shoppingCart.length > 0)
    Navigator.of(ctx.context).pushReplacementNamed('cartpage');
}

void _onAddToCart(Action action, Context<StorePageState> ctx) async {
  ProductItem product = action.payload[0];
  int count = action.payload[1];

  double amount = product.price;
  if (ctx.state.optionalMaterialSelected) {
    amount += ctx.state.selectedProduct.optionalFinishMaterialPrice;
  }

  if (ctx.state.selectedProduct.engraveAvailable) {
    var empty = true;

    if (ctx.state.engraveInputs != null) {
      for (var i = 0; i < ctx.state.engraveInputs.length; i++) {
        if (ctx.state.engraveInputs[i].trim().length > 0) {
          empty = false;
          break;
        }
      }
    }

    if (!empty) {
      amount += ctx.state.selectedProduct.engravePrice;
    }
  }
  amount *= count;

  GlobalStore.store.dispatch(
    GlobalActionCreator.addProductToShoppingCart(
      product,
      count,
      amount,
      ctx.state.engraveInputs,
      ctx.state.optionalMaterialSelected,
    ),
  );

  Navigator.of(ctx.context).pushReplacementNamed('cartpage');
}

void _onBackToProduct(Action action, Context<StorePageState> ctx) async {
  Navigator.of(ctx.context)
      .pushReplacementNamed('storepage', arguments: {'listView': false});
}
