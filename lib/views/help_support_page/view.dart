import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/widgets/about_us.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/privacy_policy.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/widgets/terms_and_conditions.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  HelpSupportPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody(dispatch: dispatch);
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;

  _MainBody({Key key, this.dispatch}) : super(key: key);

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
                automaticallyImplyLeading: true,
                leading: InkWell(
                  child: Image.asset("images/back_button.png"),
                  onTap: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.transparent,
                title: Text(
                  "Help and Support",
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
                color: Colors.white,
                child: _InnerPart(),
              ),
              drawer: SparklesDrawer(activeRoute: "helpsupportpage"),
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
  AppUser globalUser = GlobalStore.store.getState().user;

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController messageController;

  String dropDownValue = "My Order";

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: globalUser.name);
    emailController = TextEditingController(text: globalUser.email);
    messageController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/Group 196.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          color: Colors.grey[100],
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "images/chevron_right.svg",
                        width: 10.0,
                        height: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
          ),
          SizedBox(height: 19.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/Group 2341.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          color: Colors.grey[100],
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "images/chevron_right.svg",
                        width: 10.0,
                        height: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
            ),
          ),
          SizedBox(height: 19.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/Group 42342.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Terms and conditions",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          color: Colors.grey[100],
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "images/chevron_right.svg",
                        width: 10.0,
                        height: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsContitions()),
                );
              },
            ),
          ),
          SizedBox(height: 25.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(32.0),
                topLeft: Radius.circular(32.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.0),
                  TextFormField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {},
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
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
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        height: 0.7,
                        fontSize: 22,
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    onChanged: (String value) {},
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
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
                    onFieldSubmitted: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subject choice",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 7.0),
                      DropdownButton(
                        value: dropDownValue,
                        elevation: 16,
                        hint: Text(
                          "Choose",
                          style: TextStyle(fontSize: 16, color: Colors.black26),
                        ),
                        icon: RotatedBox(
                          quarterTurns: 1,
                          child: SvgPicture.asset("images/chevron_right.svg"),
                        ),
                        isDense: true,
                        isExpanded: true,
                        underline: Container(
                          height: 1,
                          color: HexColor("#C4C6D2"),
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropDownValue = newValue;
                          });
                        },
                        items: [
                          "My Order",
                          "App Feedback",
                          "I want to sell",
                          "Other",
                        ].map<DropdownMenuItem<String>>((dynamic value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Message",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 7.0),
                      TextField(
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        onChanged: (String value) {},
                        controller: messageController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: HexColor("#C4C6D2"),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: HexColor("#C4C6D2"),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: "Enter your message",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27.0),
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
                        'Send',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _onSubmit(
                            nameController.text,
                            emailController.text,
                            dropDownValue,
                            messageController.text,
                          );
                          setState(() {
                            nameController.clear();
                            emailController.clear();
                            dropDownValue = 'My Order';
                            messageController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _onSubmit(
  String nameValue,
  String emailValue,
  String dropDownValue,
  String messageValue,
) async {
  dropDownValue = dropDownValue.trim().replaceAll(" ", "_");

  await BaseGraphQLClient.instance.createSupportRequest(
    nameValue,
    emailValue,
    dropDownValue,
    messageValue,
  );
}
