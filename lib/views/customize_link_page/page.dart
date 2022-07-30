import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CustomizeLinkPage
    extends Page<CustomizeLinkPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  CustomizeLinkPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CustomizeLinkPageState>(
              adapter: null,
              slots: <String, Dependent<CustomizeLinkPageState>>{}),
          middleware: <Middleware<CustomizeLinkPageState>>[],
        );
}
