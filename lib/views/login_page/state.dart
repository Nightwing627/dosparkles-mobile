import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

class LoginPageState implements GlobalBaseState, Cloneable<LoginPageState> {
  String account = '';
  String pwd = '';
  bool isLoading = false;
  TextEditingController accountTextController;
  TextEditingController passWordTextController;
  AnimationController animationController;
  AnimationController submitAnimationController;
  FocusNode accountFocusNode;
  FocusNode pwdFocusNode;

  @override
  LoginPageState clone() {
    return LoginPageState()
      ..account = account
      ..pwd = pwd
      ..isLoading = isLoading
      ..accountFocusNode = accountFocusNode
      ..pwdFocusNode = pwdFocusNode
      ..animationController = animationController
      ..submitAnimationController = submitAnimationController
      ..accountTextController = accountTextController
      ..passWordTextController = passWordTextController;
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

LoginPageState initState(Map<String, dynamic> args) {
  return LoginPageState();
}
