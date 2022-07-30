import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SettingsPage extends Page<SettingsPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  SettingsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SettingsPageState>(
              adapter: null, slots: <String, Dependent<SettingsPageState>>{}),
          middleware: <Middleware<SettingsPageState>>[],
        );
}
