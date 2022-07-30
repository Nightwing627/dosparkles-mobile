import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ResetPasswordPage
    extends Page<ResetPasswordPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  ResetPasswordPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ResetPasswordPageState>(
              adapter: null,
              slots: <String, Dependent<ResetPasswordPageState>>{}),
          middleware: <Middleware<ResetPasswordPageState>>[],
        );
}
