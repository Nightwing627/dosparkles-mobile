import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CartPage extends Page<CartPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  CartPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CartPageState>(
              adapter: null, slots: <String, Dependent<CartPageState>>{}),
          middleware: <Middleware<CartPageState>>[],
        );
}
