import 'dart:convert';
import 'dart:ui';

import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/upload_video_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildView(
    UploadVideoState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage();
}

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
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

  Future fetchData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String chatsRaw = prefs.getString('chatsMap') ?? '{}';
    return json.decode(chatsRaw);
  }

  Stream fetchDataProcess() async* {
    while (true) {
      yield await fetchData();
      await Future<void>.delayed(Duration(seconds: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 181.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor('#8FADEB'), HexColor('#7397E2')],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
        Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            decoration: BoxDecoration(
              color: HexColor("#FAFCFF"),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: _SecondPart(),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Upload video",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.enable('smcp')],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Image.asset("images/offcanvas_icon.png"),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: SparklesDrawer(),
          bottomNavigationBar: StreamBuilder(
            stream: fetchDataProcess(),
            builder: (_, snapshot) {
              return BottomNavBarWidget(
                prefsData: snapshot.data,
                initialIndex: 0,
              );
            },
          ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _FirstPart extends StatefulWidget {
  @override
  __FirstPartState createState() => __FirstPartState();
}

class __FirstPartState extends State<_FirstPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Upload your files",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                color: HexColor("#53586F"),
                              ),
                            ),
                            SizedBox(height: 3.0),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: "File should be ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "GIF, MP4, ",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "size - 0000",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 3,
                                    color: Colors.grey[200],
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        HexColor('#8FADEB'),
                                        HexColor('#7397E2')
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp,
                                    ).createShader(
                                        Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 148.0,
                      constraints: BoxConstraints(maxWidth: 363.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/Rectangle 70.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/cloud.png",
                            width: 55.0,
                            height: 40.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "To download the file click here",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: HexColor("#6092DC"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight * 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32.0),
                  topLeft: Radius.circular(32.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0.0, -0.2), // (x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 19.0),
                  Text(
                    "Previously uploaded files",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: HexColor("#53586F"),
                    ),
                  ),
                  SizedBox(height: 23.0),
                  Row(
                    children: [
                      for (int i = 0; i < 2; i++)
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.5),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 169.0),
                              margin: EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0.0, 0.0), // (x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: Image.asset(
                                          i == 0
                                              ? "images/Mask Group.png"
                                              : "images/Mask Group (1).png",
                                          width: double.infinity,
                                          height: 130.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned.fill(
                                        top: -13.0,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                              "images/Component 16.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondPart extends StatefulWidget {
  @override
  __SecondPartState createState() => __SecondPartState();
}

class __SecondPartState extends State<_SecondPart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Select item",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                color: HexColor("#53586F"),
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              "for which you want to upload a video.",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: HexColor("#53586F"),
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 3,
                                    color: Colors.grey[200],
                                    offset: Offset(0.0, 3.0),
                                    blurRadius: 3,
                                  )
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                "2",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: [
                                        HexColor('#8FADEB'),
                                        HexColor('#7397E2')
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(1.0, 0.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp,
                                    ).createShader(
                                        Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < 2; i++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  child: Container(
                                    width: double.infinity,
                                    constraints:
                                        BoxConstraints(maxWidth: 169.0),
                                    margin: EdgeInsets.only(bottom: 16.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(0.0, 0.0), // (x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image.asset(
                                            i == 0
                                                ? "images/Mask Group.png"
                                                : "images/Mask Group (1).png",
                                            width: double.infinity,
                                            height: 130.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 3.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            i == 0
                                                ? "Modal Launch +22% Conversion"
                                                : "Lorem ipsum dolor sit dolor",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: HexColor("#53586F"),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < 2; i++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  child: Container(
                                    width: double.infinity,
                                    constraints:
                                        BoxConstraints(maxWidth: 169.0),
                                    margin: EdgeInsets.only(bottom: 14.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(0.0, 0.0), // (x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Image.asset(
                                            i == 1
                                                ? "images/Mask Group.png"
                                                : "images/Mask Group (1).png",
                                            width: double.infinity,
                                            height: 130.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 3.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            i == 1
                                                ? "Modal Launch +22% Conversion"
                                                : "Lorem ipsum dolor sit dolor",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: HexColor("#53586F"),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
