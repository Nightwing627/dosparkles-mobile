import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/terms_and_conditions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import '../../utils/colors.dart';
import 'package:http/http.dart' as http;
import 'state.dart';

Widget buildView(
  RegistrationPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody();
}

class _MainBody extends StatefulWidget {
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
              appBar: AppBar(
                elevation: 0.0,
                centerTitle: true,
                leadingWidth: 70.0,
                automaticallyImplyLeading: false,
                leading: InkWell(
                    child: Image.asset("images/back_button.png"),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed('loginpage')),
                backgroundColor: Colors.transparent,
                title: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 22,
                    color: HexColor("#53586F"),
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.enable('smcp')],
                  ),
                ),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: _InnerPart(),
              ),
            ),
            if (_isLostConnection) ConnectionLost(),
          ],
        ),
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final _formKey = GlobalKey<FormState>();
  String emailValue = '';
  String passwordValue = '';
  String firstNameValue = '';
  String lastNameValue = '';
  bool _hidePassword = true;
  bool checkboxValue = false;
  FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Follow 2 easy steps to create an account",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => firstNameValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter here',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          height: 0.7,
                          fontSize: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field must not be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 23),
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() => lastNameValue = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter here',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          height: 0.7,
                          fontSize: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field must not be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              TextFormField(
                textAlign: TextAlign.left,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() => emailValue = value);
                },
                decoration: InputDecoration(
                  hintText: 'yourname@example.com',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#C4C6D2")),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#C4C6D2")),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black26,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    height: 0.7,
                    fontSize: 22,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field must not be empty';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid Email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                textAlign: TextAlign.left,
                focusNode: _passwordNode,
                onChanged: (value) {
                  setState(() => passwordValue = value);
                },
                obscureText: _hidePassword,
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
                    padding: EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                    child: InkWell(
                      child: Icon(
                        _hidePassword ? Icons.visibility_off : Icons.visibility,
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
              SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    height: 16.0,
                    width: 20.0,
                    child: Checkbox(
                      value: this.checkboxValue,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onChanged: (bool value) {
                        setState(() {
                          this.checkboxValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 13),
                  GestureDetector(
                    child: Text(
                      'Agree with Terms & Conditions',
                      style: TextStyle(fontSize: 13.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TermsContitions()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 18),
              Container(
                width: 300.0,
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(31.0),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return HexColor("#C4C6D2");
                        return HexColor("#6092DC");
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: !checkboxValue
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            _onSubmit(
                              context,
                              emailValue,
                              passwordValue,
                              firstNameValue,
                              lastNameValue,
                            );
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _onSubmit(
  context,
  emailValue,
  passwordValue,
  firstNameValue,
  lastNameValue,
) async {
  String fullName = "$firstNameValue $lastNameValue";

  try {
    await UserInfoOperate.whenLogout();

    QueryResult resultRegister = await BaseGraphQLClient.instance
        .signUp(emailValue.trim(), passwordValue.trim());

    if (resultRegister.hasException) {
      print(resultRegister.exception.toString());
      Toast.show("Email address already exist", context,
          duration: 3, gravity: Toast.BOTTOM);
      return;
    }

    final jwt = resultRegister.data['register']['jwt'];

    if (jwt != null) {
      SharedPreferences.getInstance().then((_p) async {
        _p.setString("jwt", jwt);
        _p.setString(
            "userId", resultRegister.data['register']['user']['id'].toString());

        await UserInfoOperate.whenLogin(jwt.toString());

        QueryResult resultUpdate = await BaseGraphQLClient.instance
            .updateUserOnCreate(resultRegister.data['register']['user']['id'],
                {'fullName': fullName});
        if (resultUpdate.hasException) print(resultUpdate.exception);

        _goToMain(context);
      });
    }
  } catch (e) {
    print(e);
  }
}

Future<Map<String, dynamic>> _emailSignIn(
  BuildContext context,
  String emailValue,
  String passwordValue,
) async {
  if (emailValue != null && passwordValue != null) {
    try {
      final result = await BaseGraphQLClient.instance
          .loginWithEmail(emailValue, passwordValue);
      print('resultException: ${result.hasException}, ${result.exception}');

      if (result.hasException) {
        Toast.show("Error occurred", context,
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
        Toast.show("Wrong username or password", context,
            duration: 3, gravity: Toast.BOTTOM);
      } else {
        Toast.show(e.toString(), context, duration: 3, gravity: Toast.BOTTOM);
      }
    }
  }
  return null;
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

  await checkUserReferralLink(globalState.user);

  await Navigator.of(context).pushNamed('addphonepage', arguments: null);

  if (referralLink != null && referralLink != '') {
    await _invitedRegisteredMethod(globalState.user);
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
