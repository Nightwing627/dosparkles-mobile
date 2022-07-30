import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class ResetPasswordPageState
    implements GlobalBaseState, Cloneable<ResetPasswordPageState> {
  @override
  ResetPasswordPageState clone() {
    return ResetPasswordPageState();
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

ResetPasswordPageState initState(Map<String, dynamic> args) {
  return ResetPasswordPageState();
}
