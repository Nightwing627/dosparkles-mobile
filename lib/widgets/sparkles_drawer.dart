import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';

import 'package:com.floridainc.dosparkles/actions/user_info_operate.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/app_user.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class SparklesDrawer extends StatefulWidget {
  final globalUser = GlobalStore.store.getState().user;
  final String activeRoute;

  SparklesDrawer({Key key, this.activeRoute}) : super(key: key);

  @override
  _SparklesDrawerState createState() => _SparklesDrawerState();
}

class _SparklesDrawerState extends State<SparklesDrawer> {
  Future getInitialData() async {
    QueryResult result = await BaseGraphQLClient.instance
        .fetchStoreById(widget.globalUser.store['id']);
    return result.data['stores'][0];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 273.0),
        child: Drawer(
          child: Container(
            color: HexColor("#6092DC"),
            child: ListView(
              children: [
                Container(
                  height: 218.0,
                  child: DrawerHeader(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 18.0,
                          right: 8.0,
                          child: GestureDetector(
                            child: SvgPicture.asset(
                              "images/close_icon.svg",
                              width: 17.0,
                              height: 17.0,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 82.0,
                                height: 82.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: widget.globalUser != null &&
                                          widget.globalUser.avatarUrl != null
                                      ? Border.all(color: Colors.white)
                                      : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: widget.globalUser != null &&
                                          widget.globalUser.avatarUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: widget.globalUser.avatarUrl,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "images/user-male-circle.png",
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: Colors.white,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(height: 12.0),
                              if (widget.globalUser != null &&
                                  widget.globalUser.role == "Store Manager")
                                Text(
                                  widget.globalUser.store != null
                                      ? widget.globalUser.store['name']
                                      : "Store",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFeatures: [FontFeature.enable('smcp')],
                                  ),
                                )
                              else
                                Text(
                                  widget.globalUser != null &&
                                          widget.globalUser.name != null
                                      ? widget.globalUser.name
                                      : "User",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFeatures: [FontFeature.enable('smcp')],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: HexColor("#182465"),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32.0),
                      ),
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

                SizedBox(height: 45.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: widget.activeRoute == 'homepage'
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                            ),
                          )
                        : null,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/Vector 1221.svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    AppUser globalUser = GlobalStore.store.getState().user;

                    bool isExistFavoriteStore =
                        globalUser.storeFavorite != null;

                    if (isExistFavoriteStore) {
                      Navigator.of(context)
                          .pushReplacementNamed('storepage', arguments: null);
                      return;
                    }

                    final result = await BaseGraphQLClient.instance
                        .checkUserFields(globalUser.id);
                    if (result.hasException) print(result.exception);

                    if (result.data['users'][0]['storeFavorite'] != null) {
                      Navigator.of(context)
                          .pushReplacementNamed('storepage', arguments: null);
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          'storeselectionpage',
                          arguments: null);
                    }
                  },
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: widget.activeRoute == 'profilepage'
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                            ),
                          )
                        : null,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/Vector (1).svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('profilepage', arguments: null);
                  },
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: widget.activeRoute == 'chatpage'
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                            ),
                          )
                        : null,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/Group 136.svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "Inbox",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('chatpage', arguments: null);
                  },
                ),
                // SizedBox(height: 10.0),
                // GestureDetector(
                //   behavior: HitTestBehavior.translucent,
                //   child: Container(
                //     padding: EdgeInsets.all(12.0),
                //     margin: EdgeInsets.only(left: 13.0),
                //     decoration: BoxDecoration(),
                //     child: Stack(
                //       alignment: Alignment.centerLeft,
                //       children: [
                //         SvgPicture.asset("images/Group 139.svg"),
                //         Positioned(
                //           left: 32.0,
                //           child: Text(
                //             "Share",
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 16.0,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   onTap: () {
                //     SocialShare.shareOptions("Hello world").then((data) {});
                //   },
                // ),
                SizedBox(height: 10.0),
                widget.globalUser != null &&
                        (widget.globalUser.role == "Store Manager")
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(left: 13.0, bottom: 10.0),
                          decoration: widget.activeRoute == 'dashboardpage'
                              ? BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                )
                              : null,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              SvgPicture.asset("images/Group 232.svg"),
                              Positioned(
                                left: 32.0,
                                child: Text(
                                  "Admin Dashboard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(
                              'dashboardpage',
                              arguments: null);
                        },
                      )
                    : SizedBox.shrink(child: null),
                // : GestureDetector(
                //     behavior: HitTestBehavior.translucent,
                //     child: Container(
                //       padding: EdgeInsets.all(12.0),
                //       margin: EdgeInsets.only(left: 13.0),
                //       decoration: BoxDecoration(),
                //       child: Stack(
                //         alignment: Alignment.centerLeft,
                //         children: [
                //           SvgPicture.asset("images/Group 251.svg"),
                //           Positioned(
                //             left: 32.0,
                //             child: Text(
                //               "Upload Video",
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 16.0,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     onTap: () {
                //       Navigator.of(context).pushReplacementNamed(
                //         'storeselectionpage',
                //         arguments: null,
                //       );
                //     },
                //   ),

                // SizedBox(height: 10.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: BoxDecoration(),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/2 PT.svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "Join Sparkles",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await canLaunch("http://dosparkles.com/")
                        ? await launch("http://dosparkles.com/")
                        : throw 'Could not launch "http://dosparkles.com/"';
                  },
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: widget.activeRoute == 'helpsupportpage'
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                            ),
                          )
                        : null,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/Group 140.svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "Help and Support",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('helpsupportpage', arguments: null);
                  },
                ),
                SizedBox(height: 40.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(left: 13.0),
                    decoration: BoxDecoration(),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SvgPicture.asset("images/Group 147.svg"),
                        Positioned(
                          left: 32.0,
                          child: Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await UserInfoOperate.whenLogout();

                    Navigator.of(context).pushReplacementNamed('startpage');
                    //  Navigator.pop(context);
                  },
                ),
                SizedBox(height: 24.0),
                Center(
                  child: Text(
                    "Version 1.0.1",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
