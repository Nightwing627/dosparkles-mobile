import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum CartPageAction {
  action,
  backToProduct,
  setProductCount,
  setProductCountUpdate,
  removeCartItem,
  proceedToCheckout,
  setPaymentToken,
}

class CartPageActionCreator {
  static Action onAction() {
    return const Action(CartPageAction.action);
  }

  static Action onSetProductCount(CartItem cartItem, int count) {
    return Action(CartPageAction.setProductCount, payload: [cartItem, count]);
  }

  static Action onRemoveCartItem(CartItem cartItem) {
    return Action(CartPageAction.removeCartItem, payload: cartItem);
  }

  static Action onProceedToCheckout() {
    return Action(CartPageAction.proceedToCheckout);
  }

  static Action onSetProductCountUpdate(List<CartItem> cart) {
    return Action(CartPageAction.setProductCountUpdate, payload: cart);
  }

  static Action onBackToProduct() {
    return const Action(CartPageAction.backToProduct);
  }

  static Action onSetPaymentToken(String token) {
    return Action(CartPageAction.setPaymentToken, payload: token);
  }
}
