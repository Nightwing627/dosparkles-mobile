import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatPageState implements GlobalBaseState, Cloneable<ChatPageState> {
  PageController pageController;
  bool isFirstTime;
  @override
  ChatPageState clone() {
    return ChatPageState()
      ..pageController = pageController
      ..isFirstTime = isFirstTime
      //
      ..locale = locale
      ..user = user
      ..storesList = storesList
      ..selectedStore = selectedStore
      ..selectedProduct = selectedProduct
      ..shoppingCart = shoppingCart
      ..connectionStatus = connectionStatus;
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

ChatPageState initState(Map<String, dynamic> args) {
  return ChatPageState();
}
