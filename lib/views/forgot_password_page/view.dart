import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toast/toast.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  ForgotPasswordPageState state,
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
                centerTitle: true,
                elevation: 0.0,
                leadingWidth: 70.0,
                automaticallyImplyLeading: false,
                leading: InkWell(
                  child: Image.asset("images/back_button.png"),
                  onTap: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.transparent,
                title: Text(
                  "Forgot Password?",
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enter your email to reset your password",
                style: TextStyle(fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.10,
                ),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() => emailValue = value);
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid Email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.30,
                ),
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 48.0,
                      child: RaisedButton(
                        textColor: Colors.white,
                        elevation: 0,
                        color: HexColor("#6092DC"),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _onSubmit(context, emailValue);
                          }
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(31.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Back to ",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                            TextSpan(
                              text: "Sign in",
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
                            .pushNamed('loginpage', arguments: null);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _onSubmit(context, emailValue) async {
  try {
    QueryResult result =
        await BaseGraphQLClient.instance.forgotPassword(emailValue);
    if (result.hasException) print(result.exception);

    if (result.data != null) {
      Toast.show("Please check your email address", context,
          duration: 10, gravity: Toast.TOP);

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.remove("resetPasswordCode");

      Navigator.of(context).pushNamed('reset_passwordpage', arguments: null);
    }
  } catch (e) {
    print(e);
  }
}
