import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:com.floridainc.dosparkles/models/models.dart';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'action.dart';
import 'state.dart';

Effect<ProductPageState> buildEffect() {
  return combineEffects(<Object, Effect<ProductPageState>>{
    ProductPageAction.action: _onAction,
    ProductPageAction.goToCart: _onGoToCart,
    ProductPageAction.addToCart: _onAddToCart,
    ProductPageAction.backToProduct: _onBackToProduct,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<ProductPageState> ctx) async {
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

void _onBuild(Action action, Context<ProductPageState> ctx) {
  Future.delayed(Duration(milliseconds: 150),
      () => ctx.state.animationController.forward());
}

void _onDispose(Action action, Context<ProductPageState> ctx) {
  ctx.state.animationController.dispose();
}

void _onGoToCart(Action action, Context<ProductPageState> ctx) async {
  if (ctx.state.shoppingCart.length > 0)
    Navigator.of(ctx.context).pushReplacementNamed('cartpage');
}

void _onAddToCart(Action action, Context<ProductPageState> ctx) async {
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

void _onBackToProduct(Action action, Context<ProductPageState> ctx) async {
  Navigator.of(ctx.context)
      .pushReplacementNamed('storepage', arguments: {'listView': false});
}

void _onAction(Action action, Context<ProductPageState> ctx) {}
