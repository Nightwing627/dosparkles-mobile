import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ProductPage extends Page<ProductPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  ProductPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ProductPageState>(
              adapter: null, slots: <String, Dependent<ProductPageState>>{}),
          middleware: <Middleware<ProductPageState>>[],
        );
}
