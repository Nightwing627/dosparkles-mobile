import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ForgotPasswordPage
    extends Page<ForgotPasswordPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  ForgotPasswordPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ForgotPasswordPageState>(
              adapter: null,
              slots: <String, Dependent<ForgotPasswordPageState>>{}),
          middleware: <Middleware<ForgotPasswordPageState>>[],
        );
}
