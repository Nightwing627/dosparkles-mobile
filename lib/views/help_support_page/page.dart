import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HelpSupportPage extends Page<HelpSupportPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  HelpSupportPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HelpSupportPageState>(
              adapter: null,
              slots: <String, Dependent<HelpSupportPageState>>{}),
          middleware: <Middleware<HelpSupportPageState>>[],
        );
}
