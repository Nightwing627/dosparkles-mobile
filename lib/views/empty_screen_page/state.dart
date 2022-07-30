import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

class EmptyScreenPageState
    implements GlobalBaseState, Cloneable<EmptyScreenPageState> {
  @override
  EmptyScreenPageState clone() {
    return EmptyScreenPageState();
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

EmptyScreenPageState initState(Map<String, dynamic> args) {
  return EmptyScreenPageState();
}
