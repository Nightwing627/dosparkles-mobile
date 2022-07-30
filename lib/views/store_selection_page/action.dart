import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

enum StoreSelectionPageAction {
  action,
  storeSelected
}

class StoreSelectionPageActionCreator {
  static Action onAction() {
    return const Action(StoreSelectionPageAction.action);
  }

  static Action onStoreSelected(StoreItem store) {
    return Action(StoreSelectionPageAction.storeSelected, payload: store);
  }
}
