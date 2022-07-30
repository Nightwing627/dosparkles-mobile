import 'package:fish_redux/fish_redux.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

enum ProductPageAction {
  action,
  goToCart,
  addToCart,
  backToProduct,
  setOptionMaterialSelected,
  setEngravingInputs,
  setProductCount
}

class ProductPageActionCreator {
  static Action onAction() {
    return const Action(ProductPageAction.action);
  }

  static Action onGoToCart() {
    return const Action(ProductPageAction.goToCart);
  }

  static Action onAddToCart(ProductItem product, int count) {
    return Action(ProductPageAction.addToCart, payload: [product, count]);
  }

  static Action onBackToProduct() {
    return const Action(ProductPageAction.backToProduct);
  }

  static Action onSetEngravingInputs(List<String> inputs) {
    List<String> filtered =
        inputs.where((el) => el != null && el != '').toList();

    return Action(ProductPageAction.setEngravingInputs, payload: filtered);
  }

  static Action onSetOptionMaterialSelected(bool selected) {
    return Action(ProductPageAction.setOptionMaterialSelected,
        payload: selected);
  }

  static Action onSetProductCount(int count) {
    return Action(ProductPageAction.setProductCount, payload: count);
  }
}
