import 'package:com.floridainc.dosparkles/models/item.dart';

import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  AppLanguage._();
  static final AppLanguage instance = AppLanguage._();

  List<Item> get supportLanguages => [
        Item.fromParams(
            name: "System Default", value: ui.window.locale.languageCode),
        Item.fromParams(name: "English", value: 'en'),
       
      ];

  Future<Item> getApplanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _appLanguage = prefs.getString('appLanguage');
    if (_appLanguage != null) return Item(_appLanguage);
    return Item.fromParams(
        name: "System Default", value: ui.window.locale.languageCode);
  }
}
