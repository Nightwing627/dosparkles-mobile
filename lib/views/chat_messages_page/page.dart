import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ChatMessagesPage
    extends Page<ChatMessagesPageState, Map<String, dynamic>> {
  ChatMessagesPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ChatMessagesPageState>(
              adapter: null,
              slots: <String, Dependent<ChatMessagesPageState>>{}),
          middleware: <Middleware<ChatMessagesPageState>>[],
        );
}
