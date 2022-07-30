import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ChatPage extends Page<ChatPageState, Map<String, dynamic>> {
  ChatPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ChatPageState>(
              adapter: null, slots: <String, Dependent<ChatPageState>>{}),
          middleware: <Middleware<ChatPageState>>[],
        );
}
