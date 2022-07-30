import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';

enum HelpSupportPageAction { action, storeSelected }

class HelpSupportPageActionCreator {
  static Action onAction() {
    return const Action(HelpSupportPageAction.action);
  }

  static Action onStoreSelected(StoreItem store) {
    return Action(HelpSupportPageAction.storeSelected, payload: store);
  }
}
