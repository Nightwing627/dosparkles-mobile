import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  RegisterPageState state,
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

    return Container(
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                "Register",
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
    );
  }
}

class _InnerPart extends StatefulWidget {
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Choose a way to register",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.06,
            ),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 17,
                          child: Image.asset(
                            "images/apple_icon_small.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          child: Text(
                            "Continue with Apple",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 17,
                          child: Image.asset(
                            "images/google_icon_small.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          child: Text(
                            "Continue with Google",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 17,
                          child: Image.asset(
                            "images/snapchat_icon_small.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          child: Text(
                            "Continue with Snapchat",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 17,
                          child: Image.asset(
                            "images/path16.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          child: Text(
                            "Continue with Facebook",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 17,
                          child: Image.asset(
                            "images/email_icon_small.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 60,
                          child: Text(
                            "Continue with Email",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => null,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Text("OR", style: TextStyle(fontSize: 17)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.017),
                ButtonTheme(
                  minWidth: 300.0,
                  height: 48.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    elevation: 0,
                    color: HexColor("#6092DC"),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(31.0),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.020),
                Text(
                  "By contining you indicate thst you have read and agree our Teams of Service & Privacy Policy",
                  style: TextStyle(
                      color: Colors.black54, fontSize: 12, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
