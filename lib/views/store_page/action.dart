import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';

enum StorePageAction {
  action,
  productIndexSelected,
  goToProductPage,
  backToAllProducts,
  goToCart,
  addToCart,
  backToProduct,
  setOptionMaterialSelected,
  setEngravingInputs,
  setProductCount
}

class StorePageActionCreator {
  static Action onAction() {
    return const Action(StorePageAction.action);
  }

  static Action onProductIndexSelected(int productIndex) {
    return Action(StorePageAction.productIndexSelected, payload: productIndex);
  }

  static Action onGoToProductPage(ProductItem product) {
    return Action(StorePageAction.goToProductPage, payload: product);
  }

  static Action onBackToAllProducts() {
    return const Action(StorePageAction.backToAllProducts);
  }

  static Action onGoToCart() {
    return const Action(StorePageAction.goToCart);
  }

  static Action onAddToCart(ProductItem product, int count) {
    return Action(StorePageAction.addToCart, payload: [product, count]);
  }

  static Action onBackToProduct() {
    return const Action(StorePageAction.backToProduct);
  }

  static Action onSetEngravingInputs(List<String> inputs) {
    List<String> filtered =
        inputs.where((el) => el != null && el != '').toList();

    return Action(StorePageAction.setEngravingInputs, payload: filtered);
  }

  static Action onSetOptionMaterialSelected(bool selected) {
    return Action(StorePageAction.setOptionMaterialSelected, payload: selected);
  }

  static Action onSetProductCount(int count) {
    return Action(StorePageAction.setProductCount, payload: count);
  }
}
