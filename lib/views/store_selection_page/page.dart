import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class StoreSelectionPage extends Page<StoreSelectionPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  StoreSelectionPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<StoreSelectionPageState>(
              adapter: null, slots: <String, Dependent<StoreSelectionPageState>>{}),
          middleware: <Middleware<StoreSelectionPageState>>[],
        );
}
