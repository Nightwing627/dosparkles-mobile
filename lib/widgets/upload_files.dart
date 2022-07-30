import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadFiles extends StatefulWidget {
  @override
  _UploadFilesState createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
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
                "Upload Files",
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
                          text: "Files should be ",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: HexColor("#53586F"),
                          ),
                        ),
                        TextSpan(
                          text: "PNG, JPG, GIF, MP4, ",
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
                  SizedBox(height: 20.0),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _uploadDialog(context);
                    },
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
            SizedBox(height: 26.0),
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
                    "Your uploaded files",
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
                                              "images/Component 18.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    i == 0 ? "School logo" : "School clubs",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
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

Future<void> _uploadDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.only(left: 14.0, right: 14.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -18.0,
                  right: -11.0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          "images/close_button_terms.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  constraints: BoxConstraints(maxHeight: 485.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.0, vertical: 19.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                "images/image 2.png",
                                width: double.infinity,
                                height: 254.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: HexColor("#53586F").withOpacity(.6),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      "images/cloud_white.svg",
                                      color: Colors.white,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 7.0),
                                    Text(
                                      "Upload image",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Select what the files is being used for:",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: HexColor("#C4C6D2"),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                constraints: BoxConstraints(
                                  maxWidth: 155.0,
                                ),
                                decoration: BoxDecoration(
                                  color: HexColor("#CCD4FE"),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border:
                                      Border.all(color: HexColor("#B3C1F2")),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Text(
                                      "School logo",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: HexColor("#53586F"),
                                      ),
                                    ),
                                    Positioned.fill(
                                      top: -7.0,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 18.0,
                                          height: 18.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "images/checed_icon.svg",
                                              width: 11.0,
                                              height: 8.0,
                                              color: HexColor("#6092DC"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: 40.0,
                                constraints: BoxConstraints(
                                  maxWidth: 155.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "School clubs",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: HexColor("#53586F"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          height: 40.0,
                          constraints: BoxConstraints(
                            maxWidth: 155.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                offset: Offset(0.0, 0.0), // (x,y)
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Products",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: HexColor("#53586F"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 17.0),
                        Container(
                          width: 300.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  HexColor("#6092DC")),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(31.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Add file',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
