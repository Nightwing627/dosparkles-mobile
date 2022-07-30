import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class RegisterPageState
    implements GlobalBaseState, Cloneable<RegisterPageState> {
  @override
  RegisterPageState clone() {
    return RegisterPageState();
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

RegisterPageState initState(Map<String, dynamic> args) {
  return RegisterPageState();
}
