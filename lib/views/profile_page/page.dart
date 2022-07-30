import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ProfilePage extends Page<ProfilePageState, Map<String, dynamic>>
    with TickerProviderMixin {
  ProfilePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ProfilePageState>(
              adapter: null, slots: <String, Dependent<ProfilePageState>>{}),
          middleware: <Middleware<ProfilePageState>>[],
        );
}
