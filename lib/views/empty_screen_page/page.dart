import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EmptyScreenPage extends Page<EmptyScreenPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  EmptyScreenPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<EmptyScreenPageState>(
              adapter: null,
              slots: <String, Dependent<EmptyScreenPageState>>{}),
          middleware: <Middleware<EmptyScreenPageState>>[],
        );
}
