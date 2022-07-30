import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
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
              backgroundColor: Colors.white,
              title: Text(
                "Blog",
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          Text(
            "Lorem ipsum dolor sit amet, an consectetur".toUpperCase(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.35,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Purus interdum semper",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColor("#53586F"),
              height: 1.35,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum proin id egestas elit, ac augue lectus etiam tortor. Pretium commodo mus aliquet tincidunt.",
            style: TextStyle(
              fontSize: 16.0,
              color: HexColor("#53586F"),
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.0),
          Divider(
            thickness: 2.0,
            color: Colors.black12,
            height: 0.0,
          ),
          SizedBox(height: 12.0),
          Text(
            "Diam enim, bibendum commod dictum sit ",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: HexColor("#53586F"),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum proin id egestas elit, ac augue.",
            style: TextStyle(
              fontSize: 16.0,
              color: HexColor("#53586F"),
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.0),
          Divider(
            thickness: 2.0,
            color: Colors.black12,
            height: 0.0,
          ),
          SizedBox(height: 25.5),
          Text(
            "Lorem ipsum dolor sit amet, an consectetur".toUpperCase(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Non faucibus dictum orci mattis.",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: HexColor("#53586F"),
              height: 1.35,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum proin id egestas elit, ac augue lectus etiam tortor. Pretium commodo mus aliquet tincidunt.",
            style: TextStyle(
              fontSize: 16.0,
              color: HexColor("#53586F"),
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.0),
          Divider(
            thickness: 2.0,
            color: Colors.black12,
            height: 0.0,
          ),
          SizedBox(height: 12.0),
          Text(
            "Tellus semper ",
            style: TextStyle(
              fontSize: 18.0,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: HexColor("#53586F"),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Elementum proin id egestas elit, ac augue.",
            style: TextStyle(
              fontSize: 16.0,
              height: 1.35,
              color: HexColor("#53586F"),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
