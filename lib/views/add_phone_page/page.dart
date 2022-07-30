import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AddPhonePage extends Page<AddPhonePageState, Map<String, dynamic>>
    with TickerProviderMixin {
  AddPhonePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AddPhonePageState>(
              adapter: null, slots: <String, Dependent<AddPhonePageState>>{}),
          middleware: <Middleware<AddPhonePageState>>[],
        );
}
