import 'dart:async';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/app_user.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'action.dart';
import 'state.dart';
import 'package:toast/toast.dart';
import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';

Effect<LoginPageState> buildEffect() {
  return combineEffects(<Object, Effect<LoginPageState>>{
    LoginPageAction.action: _onAction,
    LoginPageAction.loginclicked: _onLoginClicked,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose
  });
}

void _onInit(Action action, Context<LoginPageState> ctx) async {
  ctx.state.accountFocusNode = FocusNode();
  ctx.state.pwdFocusNode = FocusNode();
  final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));
  ctx.state.submitAnimationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 1000));
  ctx.state.accountTextController = TextEditingController();
  ctx.state.passWordTextController = TextEditingController();

  SharedPreferences.getInstance().then((_p) async {
    final savedToken = _p.getString('jwt') ?? '';
    if (savedToken.isNotEmpty) {
      await UserInfoOperate.whenLogin(savedToken.toString());
      await BaseGraphQLClient.instance.me();
      _goToMain(ctx);
    }
  });
}

void _onBuild(Action action, Context<LoginPageState> ctx) {
  Future.delayed(Duration(milliseconds: 150),
      () => ctx.state.animationController.forward());
}

void _onDispose(Action action, Context<LoginPageState> ctx) {
  ctx.state.animationController.dispose();
  ctx.state.accountFocusNode.dispose();
  ctx.state.pwdFocusNode.dispose();
  ctx.state.submitAnimationController.dispose();
  ctx.state.accountTextController.dispose();
  ctx.state.passWordTextController.dispose();
}

void _onAction(Action action, Context<LoginPageState> ctx) {}

Future _onLoginClicked(Action action, Context<LoginPageState> ctx) async {
  final _result = await _emailSignIn(action, ctx);

  if (_result == null) return;

  if (_result['jwt'].toString().isNotEmpty) {
    SharedPreferences.getInstance().then((_p) async {
      _p.setString("jwt", _result['jwt']);
      _p.setString("userId", _result['user']['id'].toString());
      print('jwt: ${_result['jwt'].toString()}');

      await UserInfoOperate.whenLogin(_result['jwt'].toString());
      _goToMain(ctx);
    });
  }
}

void _goToMain(Context<LoginPageState> ctx) async {
  ctx.dispatch(LoginPageActionCreator.onSetIsLoading(true));

  var globalState = GlobalStore.store.getState();

  await checkUserReferralLink(globalState.user);

  await checkUserPhoneNumber(globalState.user, ctx.context);

  if (globalState.storesList != null && globalState.storesList.length > 0) {
    for (var i = 0; i < globalState.storesList.length; i++) {
      var store = globalState.storesList[i];
      if (globalState.user.storeFavorite != null &&
          globalState.user.storeFavorite['id'] == store.id) {
        GlobalStore.store.dispatch(
          GlobalActionCreator.setSelectedStore(store),
        );
        Navigator.of(ctx.context).pushReplacementNamed('storepage');
        return null;
      }
    }
  }

  Navigator.of(ctx.context).pushReplacementNamed('storeselectionpage');

  ctx.dispatch(LoginPageActionCreator.onSetIsLoading(false));
}

Future checkUserReferralLink(AppUser globalUser) async {
  if (globalUser.referralLink == null || globalUser.referralLink == '') {
    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: 'Example Branch Flutter Link',
      imageUrl: 'https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png',
      contentDescription:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec:
          DateTime.now().add(Duration(days: 365)).millisecondsSinceEpoch,
    );
    FlutterBranchSdk.registerView(buo: buo);

    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'google',
        feature: 'referral',
        alias: 'referralToken=${Uuid().v4()}',
        stage: 'new share',
        campaign: 'xxxxx',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');

    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      try {
        await BaseGraphQLClient.instance
            .setUserReferralLink(globalUser.id, response.result);

        globalUser.referralLink = response.result;
        GlobalStore.store.dispatch(GlobalActionCreator.setUser(globalUser));
      } catch (e) {
        print(e);
      }
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }
}

Future<Map<String, dynamic>> _emailSignIn(
    Action action, Context<LoginPageState> ctx) async {
  if (ctx.state.accountTextController.text != '' &&
      ctx.state.passWordTextController.text != '') {
    try {
      final _email = ctx.state.accountTextController.text.trim();
      final result = await BaseGraphQLClient.instance
          .loginWithEmail(_email, ctx.state.passWordTextController.text);
      print('resultException: ${result.hasException}, ${result.exception}');

      if (result.hasException) {
        Toast.show("Error occurred", ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        return null;
      }
      return result.data['login'];
    } on Exception catch (e) {
      print(e);
      if (e.toString() ==
              'DioError [DioErrorType.RESPONSE]: Http status error [400]' ||
          e.toString() ==
              'DioError [DioErrorType.RESPONSE]: Http status error [403]') {
        Toast.show("Wrong username or password", ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        ctx.state.submitAnimationController.reverse();
      } else {
        Toast.show(e.toString(), ctx.context,
            duration: 3, gravity: Toast.BOTTOM);
        ctx.state.submitAnimationController.reverse();
      }
    }
  }
  return null;
}

Future checkUserPhoneNumber(AppUser globalUser, context) async {
  final result =
      await BaseGraphQLClient.instance.checkUserFields(globalUser.id);
  if (result.hasException) print(result.exception);

  if (result.data['users'][0]['phoneNumber'] == null) {
    await Navigator.of(context).pushNamed('addphonepage', arguments: null);
  }
}
