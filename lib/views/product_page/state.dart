import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

class ProductPageState implements GlobalBaseState, Cloneable<ProductPageState> {
  AnimationController animationController;
  List<String> engraveInputs;
  bool optionalMaterialSelected;
  int productQuantity;

  @override
  ProductPageState clone() {
    return ProductPageState()
      ..animationController = animationController
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

ProductPageState initState(Map<String, dynamic> args) {
  return ProductPageState()
    ..productQuantity = 1
    ..optionalMaterialSelected = false;
}
