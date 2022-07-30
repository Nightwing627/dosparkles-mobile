import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UploadVideo extends Page<UploadVideoState, Map<String, dynamic>>
    with TickerProviderMixin {
  UploadVideo()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<UploadVideoState>(
              adapter: null, slots: <String, Dependent<UploadVideoState>>{}),
          middleware: <Middleware<UploadVideoState>>[],
        );
}
