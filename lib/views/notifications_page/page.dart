import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NotificationsPage
    extends Page<NotificationsPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  NotificationsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<NotificationsPageState>(
              adapter: null,
              slots: <String, Dependent<NotificationsPageState>>{}),
          middleware: <Middleware<NotificationsPageState>>[],
        );
}
