import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:email_validator/email_validator.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/services.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'action.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'state.dart';
import 'package:http/http.dart' as http;

Widget buildView(
    LoginPageState state, Dispatch dispatch, ViewService viewService) {
  return _MainBody(state: state, dispatch: dispatch);
}

class _MainBody extends StatefulWidget {
  final LoginPageState state;
  final Dispatch dispatch;

  _MainBody({Key key, this.state, this.dispatch}) : super(key: key);

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  bool _isLostConnection = false;

  checkInternetConnectivity() {
    String _connectionStatus = GlobalStore.store.getState().connectionStatus;
    if (_connectionStatus == 'ConnectivityResult.none') {
      setState(() {
        _isLostConnection = true;
      });
    } else {
      setState(() {
        _isLostConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: HexColor("#F2F6FA"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/background_lines_top.png",
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/background_lines_bottom.png",
                fit: BoxFit.contain,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: null,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: _InnerPart(
                  state: widget.state,
                  dispatch: widget.dispatch,
                ),
              ),
            ),
            if (widget.state.isLoading)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.withOpacity(.4),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_isLostConnection) ConnectionLost(),
          ],
        ),
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  final LoginPageState state;
  final Dispatch dispatch;

  _InnerPart({Key key, this.state, this.dispatch}) : super(key: key);

  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  FocusNode _passwordNode = FocusNode();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    // facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Image.asset("images/Group 319.png"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              Text(
                "Welcome to Sparkles!",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  fontFeatures: [FontFeature.enable('smcp')],
                  color: HexColor("#53586F"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.002),
              Text(
                "Please sign in to continue.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    controller: widget.state.accountTextController,
                    decoration: InputDecoration(
                      hintText: 'yourname@example.com',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black26,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      widget.dispatch(LoginPageActionCreator.onLoginClicked());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      } else if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid Email address';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 21),
                  TextFormField(
                    textAlign: TextAlign.left,
                    focusNode: _passwordNode,
                    obscureText: _hidePassword,
                    controller: widget.state.passWordTextController,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Password',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                      suffixIcon: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                        child: InkWell(
                          child: Icon(
                            _hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                            _passwordNode.canRequestFocus = false;
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      widget.dispatch(LoginPageActionCreator.onLoginClicked());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      if (value.length < 8) {
                        return 'Field value should contain at least 8 characters';
                      }
                      if (value.length > 16) {
                        return 'Field value should not exceed 16 characters.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('forgot_passwordpage', arguments: null);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  Container(
                    width: 300.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(HexColor("#6092DC")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          widget.dispatch(
                              LoginPageActionCreator.onLoginClicked());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.018),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have account yet? ",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('registrationpage', arguments: null);
                    },
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Column(
                children: [
                  Text(
                    "Or sign in with",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Image.asset(
                          "images/high-quality-images/output-onlinepngtools.png",
                          fit: BoxFit.fitWidth,
                          width: 50.0,
                        ),
                        onTap: () {
                          _goolgeSignIn(_googleSignIn, context);
                        },
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Image.asset(
                          "images/high-quality-images/output-onlinepngtools (3).png",
                          fit: BoxFit.fitWidth,
                          width: 50.0,
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Image.asset(
                          "images/high-quality-images/output-onlinepngtools (1).png",
                          fit: BoxFit.fitWidth,
                          width: 50.0,
                        ),
                        onTap: () {
                          _facebookSignIn(context, facebookSignIn);
                        },
                      ),
                      SizedBox(width: 16),
                      if (Platform.isIOS || Platform.isMacOS)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Image.asset(
                            "images/high-quality-images/output-onlinepngtools (2).png",
                            fit: BoxFit.fitWidth,
                            width: 50.0,
                          ),
                          onTap: () {
                            _appleSignIn(context);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _goolgeSignIn(_googleSignIn, context) async {
  try {
    await _googleSignIn.signOut();
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await user.authentication;

    if (googleSignInAuthentication.accessToken != null) {
      Response response = await http.get(
        '${AppConfig.instance.baseApiHost}/auth/google/callback?access_token=${googleSignInAuthentication.accessToken}',
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      await UserInfoOperate.whenLogin(responseBody['jwt'].toString());
      if (responseBody['jwt'] != null) {
        SharedPreferences.getInstance().then((_p) async {
          await _p.setString("jwt", responseBody['jwt']);
          _p.setString("userId", responseBody['user']['id'].toString());

          _goToMain(context);
        });
      }
    } else {
      Toast.show("Account with this email already exist", context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  } catch (error) {
    print(error);
  }
}

void _facebookSignIn(context, facebookSignIn) async {
  await facebookSignIn.logOut();
  final FacebookLoginResult result =
      await facebookSignIn.logIn(['public_profile', 'email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final FacebookAccessToken accessToken = result.accessToken;

      if (accessToken == null) {
        Toast.show("Account with this email already exist", context,
            duration: 3, gravity: Toast.BOTTOM);
        return;
      }

      Response response = await http.get(
        '${AppConfig.instance.baseApiHost}/auth/facebook/callback?access_token=${accessToken.token}',
      );
      Map<String, dynamic> responseBody = json.decode(response.body);

      await UserInfoOperate.whenLogin(responseBody['jwt'].toString());
      if (responseBody['jwt'] != null) {
        SharedPreferences.getInstance().then((_p) async {
          await _p.setString("jwt", responseBody['jwt']);
          _p.setString("userId", responseBody['user']['id'].toString());

          _goToMain(context);
        });
      }

      break;
    case FacebookLoginStatus.cancelledByUser:
      print('Login cancelled by the user.');
      break;
    case FacebookLoginStatus.error:
      print('Something went wrong with the login process.\n'
          'Here\'s the error Facebook gave us: ${result.errorMessage}');
      break;
  }
}

void _appleSignIn(context) async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
      clientId: 'com.floridainc.dosparkles',
      redirectUri: Uri.parse(
        'https://backend.dosparkles.com/auth/apple/callback',
      ),
    ),
  );

  if (credential.authorizationCode == null) {
    Toast.show("Account with this email already exist", context,
        duration: 3, gravity: Toast.BOTTOM);
    return;
  }

  Response response = await http.get(
    '${AppConfig.instance.baseApiHost}/auth/apple/callback?access_token=${credential.authorizationCode}',
  );
  printWrapped(response.body);

  Map<String, dynamic> responseBody = json.decode(response.body);

  await UserInfoOperate.whenLogin(responseBody['jwt'].toString());

  if (responseBody['jwt'] != null) {
    SharedPreferences.getInstance().then((_p) async {
      await _p.setString("jwt", responseBody['jwt']);
      _p.setString("userId", responseBody['user']['id'].toString());

      _goToMain(context);
    });
  }
}

void _goToMain(BuildContext context) async {
  // await FirebaseMessaging.instance.getToken().then((String token) async {
  //   if (token != null) {
  //     print("_goToMain Push Messaging token: $token");

  //     await SharedPreferences.getInstance().then((_p) async {
  //       var userId = _p.getString("userId");
  //       await UserInfoOperate.savePushToken(userId, token);
  //     });
  //   }
  // });

  var globalState = GlobalStore.store.getState();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String referralLink = _prefs.getString("referralLink");

  if (referralLink != null && referralLink != '') {
    await setUserFavoriteStore(globalState.user, referralLink);
  }

  await Navigator.of(context).pushNamed('addphonepage', arguments: null);

  if (referralLink != null && referralLink != '') {
    await _invitedRegisteredMethod(globalState.user);
    await checkUserReferralLink(globalState.user);
  }

  for (int i = 0; i < globalState.storesList.length; i++) {
    var store = globalState.storesList[i];
    if (globalState.user.storeFavorite != null &&
        globalState.user.storeFavorite['id'] == store.id) {
      GlobalStore.store.dispatch(
        GlobalActionCreator.setSelectedStore(store),
      );
      Navigator.of(context).pushReplacementNamed('storepage');
      return null;
    }
  }

  Navigator.of(context).pushReplacementNamed('storeselectionpage');
}

Future<void> _invitedRegisteredMethod(AppUser globalUser) async {
  SharedPreferences.getInstance().then((_p) async {
    String referralLink = _p.getString("referralLink");

    print("----------------------------------------------------");
    print("$referralLink");
    print("----------------------------------------------------");

    if (referralLink != null && referralLink != '') {
      Response result = await http.post(
        '${AppConfig.instance.baseApiHost}/friend-invites/inviteConfirm',
        body: {
          'referralLink': "$referralLink",
          'phoneNumber':
              "${globalUser != null && globalUser.phoneNumber != null ? globalUser.phoneNumber.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}",
        },
      );
      _p.setString("referralLink", null);

      // print("Registered : " + result.body);
    }
  });
}

Future checkUserReferralLink(AppUser globalUser) async {
  if (globalUser.referralLink == null || globalUser.referralLink == '') {
    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      //canonicalUrl: '',
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
      print("referral link : ${response.result}");

      try {
        QueryResult result = await BaseGraphQLClient.instance
            .setUserReferralLink(globalUser.id, response.result);
        if (result.hasException) print(result.exception);

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

Future setUserFavoriteStore(AppUser globalUser, String referralLink) async {
  try {
    QueryResult resultLink =
        await BaseGraphQLClient.instance.fetchUserByReferralLink(referralLink);
    if (resultLink.hasException) print(resultLink.exception);

    if (resultLink.data != null &&
        resultLink.data['users'] != null &&
        resultLink.data['users'].length > 0 != null &&
        resultLink.data['users'][0]['referralLink'] != null) {
      if (resultLink.data['users'][0]['referralLink'] == referralLink) {
        Map favoriteStore = resultLink.data['users'][0]['storeFavorite'];

        QueryResult resultStore = await BaseGraphQLClient.instance
            .setUserFavoriteStore(globalUser.id, favoriteStore['id']);
        if (resultStore.hasException) print(resultStore.exception);

        if (resultStore.data != null &&
            resultStore.data['updateUser'] != null &&
            resultStore.data['updateUser']['user'] != null &&
            resultStore.data['updateUser']['user']['storeFavorite'] != null) {
          globalUser.storeFavorite =
              resultStore.data['updateUser']['user']['storeFavorite'];

          GlobalStore.store.dispatch(GlobalActionCreator.setUser(globalUser));
        }
      }
    }
  } catch (e) {
    print(e);
  }
}
