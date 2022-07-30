import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';

class UploadVideoState implements GlobalBaseState, Cloneable<UploadVideoState> {
  @override
  UploadVideoState clone() {
    return UploadVideoState();
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

UploadVideoState initState(Map<String, dynamic> args) {
  return UploadVideoState();
}
