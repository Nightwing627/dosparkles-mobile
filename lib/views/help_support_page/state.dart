import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

class HelpSupportPageState
    implements GlobalBaseState, Cloneable<HelpSupportPageState> {
  AnimationController animationController;

  @override
  HelpSupportPageState clone() {
    return HelpSupportPageState()
      ..animationController = animationController
      //
      ..locale = locale
      ..user = user
      ..storesList = storesList
      ..selectedStore = selectedStore
      ..selectedProduct = selectedProduct
      ..shoppingCart = shoppingCart;
  }

  @override
  Locale locale;

  @override
  AppUser user;

  @override
  List<StoreItem> storesList;

  @override
  StoreItem selectedStore;

  @override
  ProductItem selectedProduct;

  @override
  List<CartItem> shoppingCart;

  @override
  String connectionStatus;
}

HelpSupportPageState initState(Map<String, dynamic> args) {
  return HelpSupportPageState();
}
