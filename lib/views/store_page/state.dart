import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:flutter/material.dart';

class StorePageState implements GlobalBaseState, Cloneable<StorePageState> {
  AnimationController animationController;
  bool listView;
  int productIndex;

  List<String> engraveInputs;
  bool optionalMaterialSelected;
  int productQuantity;

  @override
  StorePageState clone() {
    return StorePageState()
      ..animationController = animationController
      ..listView = listView
      ..productIndex = productIndex
      ..engraveInputs = engraveInputs
      ..optionalMaterialSelected = optionalMaterialSelected
      ..productQuantity = productQuantity
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

StorePageState initState(Map<String, dynamic> args) {
  StorePageState state = StorePageState();
  state.productQuantity = 1;
  state.optionalMaterialSelected = false;
  state.listView = true;

  if (args != null) {
    if (args['listView'] != null) {
      state.listView = args['listView'];
    }
  }

  return state;
}
