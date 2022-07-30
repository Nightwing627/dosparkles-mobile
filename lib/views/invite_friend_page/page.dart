import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class InviteFriendPage extends Page<InviteFriendPageState, Map<String, dynamic>>
    with TickerProviderMixin {
  InviteFriendPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<InviteFriendPageState>(
              adapter: null,
              slots: <String, Dependent<InviteFriendPageState>>{}),
          middleware: <Middleware<InviteFriendPageState>>[],
        );
}
