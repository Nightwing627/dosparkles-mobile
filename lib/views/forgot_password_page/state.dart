import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class ForgotPasswordPageState
    implements GlobalBaseState, Cloneable<ForgotPasswordPageState> {
  @override
  ForgotPasswordPageState clone() {
    return ForgotPasswordPageState();
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

ForgotPasswordPageState initState(Map<String, dynamic> args) {
  return ForgotPasswordPageState();
}
