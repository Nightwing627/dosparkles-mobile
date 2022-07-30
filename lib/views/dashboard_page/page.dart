import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DashboardPage extends Page<DashboardPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  DashboardPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<DashboardPageState>(
              adapter: null, slots: <String, Dependent<DashboardPageState>>{}),
          middleware: <Middleware<DashboardPageState>>[],
        );
}
