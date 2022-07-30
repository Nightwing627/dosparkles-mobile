import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RegistrationPage extends Page<RegistrationPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  RegistrationPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RegistrationPageState>(
              adapter: null,
              slots: <String, Dependent<RegistrationPageState>>{}),
          middleware: <Middleware<RegistrationPageState>>[],
        );
}
