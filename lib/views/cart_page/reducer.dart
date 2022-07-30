import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'action.dart';
import 'state.dart';

Reducer<CartPageState> buildReducer() {
  return asReducer(
    <Object, Reducer<CartPageState>>{
      CartPageAction.action: _onAction,
      CartPageAction.setProductCountUpdate: _onSetProductCountUpdate,
      CartPageAction.setPaymentToken: _onSetPaymentToken
    },
  );
}

CartPageState _onAction(CartPageState state, Action action) {
  final CartPageState newState = state.clone();
  return newState;
}

CartPageState _onSetProductCountUpdate(CartPageState state, Action action) {
  List<CartItem> cart = action.payload;

  final CartPageState newState = state.clone();
  newState.shoppingCart = cart;
  return newState;
}

CartPageState _onSetPaymentToken(CartPageState state, Action action) {
  String token = action.payload;

  final CartPageState newState = state.clone();
  newState.paymentToken = token;
  return newState;
}
