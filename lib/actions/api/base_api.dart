import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'request.dart';

class BaseApi {
  BaseApi._();
  static final BaseApi _instance = BaseApi._();
  static BaseApi get instance => _instance;

  final Request _http = Request(AppConfig.instance.baseApiHost);
}
