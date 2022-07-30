import 'package:flutter/material.dart';
import 'dart:convert' show json;

class AppConfig {
  AppConfig._();

  static final AppConfig instance = AppConfig._();

  dynamic _config;

  String get graphQLHttpLink => _config['graphQLHttpLink'];

  String get baseApiHost => _config['baseApiHost'];

  Future init(BuildContext context) async {
    final _jsonStr = await _getConfigJson(context);
    if (_jsonStr == null) {
      return;
    }
    _config = json.decode(_jsonStr);
  }

  Future<String> _getConfigJson(BuildContext context) async {
    try {
      final _jsonStr =
          await DefaultAssetBundle.of(context).loadString("appconfig.json");
      return _jsonStr;
    } on Exception catch (_) {
      return null;
    }
  }
}
