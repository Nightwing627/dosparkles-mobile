import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:shared_preferences/shared_preferences.dart';
import 'action.dart';
import 'state.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';
import 'package:com.floridainc.dosparkles/actions/stores_info_operate.dart';

Effect<StartPageState> buildEffect() {
  return combineEffects(<Object, Effect<StartPageState>>{
    StartPageAction.action: _onAction,
    StartPageAction.onStart: _onStart,
    Lifecycle.build: _onBuild,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<StartPageState> ctx) {}

Future _loadData(BuildContext context) async {
  await AppConfig.instance.init(context);
  await UserInfoOperate.whenAppStart();
  await StoresInfoOperate.whenAppStart();

  GlobalStore.store
      .dispatch(GlobalActionCreator.setShoppingCart(new List<CartItem>()));
}

void _onInit(Action action, Context<StartPageState> ctx) async {
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.setAutoInitEnabled(true);

  ctx.state.pageController = PageController();

  await _loadData(ctx.context);

  SharedPreferences.getInstance().then((_p) async {
    final savedToken = _p.getString('jwt') ?? '';
    if (savedToken.isEmpty) {
      ctx.dispatch(StartPageActionCreator.setIsFirst(true));
      return null;
    }

    final _isFirst = _p.getBool('firstStart') ?? true;
    if (!_isFirst) {
      await _pushToSignInPage(ctx.context);
    } else
      ctx.dispatch(StartPageActionCreator.setIsFirst(_isFirst));
  });
}

void _onDispose(Action action, Context<StartPageState> ctx) {
  ctx.state.pageController.dispose();
}

void _onBuild(Action action, Context<StartPageState> ctx) {}

void _onStart(Action action, Context<StartPageState> ctx) async {
  SharedPreferences.getInstance().then((_p) {
    _p.setBool('firstStart', false);
  });
  await _pushToSignInPage(ctx.context);
}

Future _pushToSignInPage(BuildContext context) async {
  SharedPreferences.getInstance().then((_p) async {
    String referralLink = _p.getString("referralLink") ?? '';
    String resetPasswordCode = _p.getString("resetPasswordCode") ?? '';

    if (referralLink != null && referralLink.isNotEmpty) {
      Navigator.of(context).pushNamed('registrationpage');
      return;
    }

    if (resetPasswordCode != null && resetPasswordCode.isNotEmpty) {
      Navigator.of(context).pushNamed('reset_passwordpage');
      return;
    }

    Navigator.of(context).pushReplacementNamed('loginpage');
  });
}
