import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';

import 'state.dart';

Widget buildView(
  ResetPasswordPageState state,
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
                    onTap: () => goBack(context)),
                backgroundColor: Colors.transparent,
                title: Text(
                  "Change Password",
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
  String oldValue = '';
  bool oldHide = true;
  String newValue = '';
  bool newHide = true;
  String repeatValue = '';
  String codeFromEmail = '';
  bool repeatHide = true;
  FocusNode _passwordNode1 = FocusNode();
  FocusNode _passwordNode2 = FocusNode();
  FocusNode _passwordNode3 = FocusNode();

  TextEditingController _codeFromEmailController;

  @override
  Widget build(BuildContext context) {
    _codeFromEmailController = new TextEditingController(text: '');

    SharedPreferences.getInstance().then((_p) {
      String code = _p.getString("resetPasswordCode");
      print('code ${code}');
      if (code != null && code != '')
        _codeFromEmailController.value = new TextEditingValue(text: code);
    });

    return Container(
      height: MediaQuery.of(context).size.height -
          Scaffold.of(context).appBarMaxHeight,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.left,
                    focusNode: _passwordNode1,
                    controller: _codeFromEmailController,
                    onChanged: (value) {
                      setState(() {
                        codeFromEmail = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelText: 'Code From Email',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: oldHide,
                    focusNode: _passwordNode1,
                    onChanged: (value) {
                      setState(() {
                        oldValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      labelText: 'Old Password',
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
                            oldHide ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              oldHide = !oldHide;
                            });

                            _passwordNode1.canRequestFocus = false;
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: newHide,
                    focusNode: _passwordNode2,
                    onChanged: (value) {
                      setState(() {
                        newValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'New Password',
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
                            newHide ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              newHide = !newHide;
                            });

                            _passwordNode2.canRequestFocus = false;
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  TextFormField(
                    textAlign: TextAlign.left,
                    obscureText: repeatHide,
                    focusNode: _passwordNode3,
                    onChanged: (value) {
                      setState(() {
                        repeatValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter here',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black26),
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#C4C6D2")),
                      ),
                      suffixIcon: Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 12.0, top: 12.0),
                        child: InkWell(
                          child: Icon(
                            repeatHide
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black26,
                          ),
                          onTap: () {
                            setState(() {
                              repeatHide = !repeatHide;
                            });

                            _passwordNode3.canRequestFocus = false;
                          },
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field must not be empty';
                      } else if (value != newValue) {
                        return 'Password are not matching';
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
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled))
                        return HexColor("#C4C6D2");
                      return HexColor("#6092DC");
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(31.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: repeatValue != newValue ||
                          repeatValue.length == 0 ||
                          newValue.length == 0 ||
                          oldValue.length == 0
                      ? null
                      : () {
                          if (_formKey.currentState.validate()) {
                            _onSubmit(context, oldValue, newValue, repeatValue);
                          }
                        },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
            ],
          ),
        ),
      ),
    );
  }
}

void goBack(context) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.remove("resetPasswordCode");

   Navigator.of(context).pushReplacementNamed('loginpage');
}

void _onSubmit(context, oldValue, newValue, repeatValue) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String code = _prefs.getString("resetPasswordCode");

  if (code == null || code == '') return null;

  try {
    QueryResult result = await BaseGraphQLClient.instance.resetPassword(
      code,
      newValue,
      repeatValue,
    );
    if (result.hasException) print(result.exception);

    if (!result.hasException && result.data != null) {
      Toast.show("Your password successfully changed", context,
          duration: 3, gravity: Toast.TOP);

      _prefs.setString('jwt', null);
      Navigator.of(context).pushNamed('startpage', arguments: null);
    }
    _prefs.setString('resetPasswordCode', null);
  } catch (e) {
    print(e);
  }
}
