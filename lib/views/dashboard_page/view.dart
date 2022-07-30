import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.dart';

Widget buildView(
    DashboardPageState state, Dispatch dispatch, ViewService viewService) {
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
            child: _MainBody(),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "My Profile",
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
          drawer: SparklesDrawer(activeRoute: "dashboardpage"),
          floatingActionButton: FloatingActionButton(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [HexColor('#CBD3FD'), HexColor('#899CD6')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Vector 21312312.svg",
                  width: 21.0,
                  height: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('helpsupportpage', arguments: null);
            },
          ),
          bottomNavigationBar: StreamBuilder(
            stream: fetchDataProcess(),
            builder: (_, snapshot) {
              return BottomNavBarWidget(
                prefsData: snapshot.data,
                initialIndex: 1,
              );
            },
          ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _MainBody extends StatefulWidget {
  final globalUser = GlobalStore.store.getState().user;

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  String selectedDate = DateTime.now().toString();
  List filteredList;
  Map<String, dynamic> topStatistics = {
    'sales': 0,
    'customers': 0,
    'inbox': 0,
  };

  Map<String, dynamic> bottomStatistics = {
    'utitsSold': 0,
    'revenue': 0,
    'totalCost': 0,
    'profit': 0
  };
  List<Asset> pickedImages = <Asset>[];
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: pickedImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Gallery",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      pickedImages = resultList;
    });
  }

  String formatDateTimeToMY(String date) {
    return DateFormat('LLLL yyyy').format(DateTime.parse(date));
  }

  Future getInitialData() async {
    QueryResult result = await BaseGraphQLClient.instance
        .fetchStoreById(widget.globalUser.store['id']);
    return result.data['stores'][0];
  }

  void _getStatistics(DateTime date) async {
    bool isStoreOwner =
        GlobalStore.store.getState().user.role == 'Store Manager';

    DateTime startDate = DateTime(date.year, date.month);
    DateTime endDate = DateTime(date.year, date.month + 1, 0);

    Response result = await http.post(
      '${AppConfig.instance.baseApiHost}/analytics/getStatistics',
      body: {
        'startDate': "$startDate",
        'endDate': "$endDate",
        'storeId': isStoreOwner ? "${widget.globalUser.store['id']}" : '',
      },
    );

    Map<String, dynamic> statistics = json.decode(result.body);

    setState(() {
      if (statistics['topStatistics'] != null)
        topStatistics = statistics['topStatistics'];

      if (statistics['bottomStatistics'] != null)
        bottomStatistics = statistics['bottomStatistics'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getStatistics(DateTime.parse(selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    selectedDate = formatDateTimeToMY(
        selectedDate.length < 15 ? DateTime.now().toString() : selectedDate);
    return FutureBuilder(
        future: getInitialData(),
        builder: (context, snapshot) {
          var store = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30.0),
                Stack(
                  children: [
                    Container(
                      width: 82.0,
                      height: 82.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: store != null && store['thumbnail'] != null
                            ? CachedNetworkImage(
                                imageUrl: AppConfig.instance.baseApiHost +
                                    store['thumbnail']['url'],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "images/image-not-found.png",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    if (_isLoading)
                      Positioned.fill(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.4),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text(
                  store != null ? store['name'] : "Store",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15.0),
                Stack(
                  children: [
                    Container(
                      width: 194.0,
                      height: 34.0,
                      padding: EdgeInsets.only(
                        top: 9.0,
                        bottom: 9.0,
                        left: 9.0,
                        right: 44.0,
                      ),
                      decoration: BoxDecoration(
                        color: HexColor("#F0F2FF"),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          selectedDate.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: Container(
                        width: 34.0,
                        height: 34.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.0),
                          color: Colors.white,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(0.0)),
                            elevation: MaterialStateProperty.all(5.0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            shadowColor:
                                MaterialStateProperty.all(Colors.grey[50]),
                          ),
                          child: SvgPicture.asset(
                            "images/Calendar.svg",
                            width: 16.0,
                            height: 16.0,
                          ),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(1960),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              locale: const Locale("en", "US"),
                            ).then((date) {
                              _getStatistics(date);
                              setState(() {
                                selectedDate = date.toString();
                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${topStatistics != null && topStatistics['sales'] != null ? topStatistics['sales'] : 0}",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: HexColor("#53586F"),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          "Sales",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.black12,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${topStatistics != null && topStatistics['customers'] != null ? topStatistics['customers'] : 0}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: HexColor("#53586F"),
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          "Customers",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.0,
                      width: 1.0,
                      color: Colors.black12,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${topStatistics != null && topStatistics['inbox'] != null ? topStatistics['inbox'] : 0}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: HexColor("#53586F"),
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          "Inbox",
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18.0),
                Container(
                  width: double.infinity,
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 18.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Last 24 Hours At A Glance",
                            style: TextStyle(
                              color: HexColor("#6092DC"),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          SvgPicture.asset(
                            "images/Group 254.svg",
                            color: HexColor("#6092DC"),
                            width: 16.0,
                            height: 16.0,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "images/Group 256.svg",
                                    color: HexColor("#B3C1F2"),
                                    width: 22.0,
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 11.0),
                              Text(
                                "${bottomStatistics != null && bottomStatistics['utitsSold'] != null ? bottomStatistics['utitsSold'] : 0}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                "Units Sold",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "images/Group 12.svg",
                                    color: HexColor("#B3C1F2"),
                                    width: 22.0,
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 11.0),
                              Text(
                                "\$${bottomStatistics != null && bottomStatistics['revenue'] != null ? bottomStatistics['revenue'] : 0}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                "Revenue",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "images/Page 112.svg",
                                    color: HexColor("#B3C1F2"),
                                    width: 22.0,
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 11.0),
                              Text(
                                "\$${bottomStatistics != null && bottomStatistics['totalCost'] != null ? bottomStatistics['totalCost'] : 0}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                "Cost",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#FAFCFF"),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200],
                                      offset: Offset(0.0, 0.0), // (x,y)
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "images/Group 257.svg",
                                    color: HexColor("#B3C1F2"),
                                    width: 22.0,
                                    height: 22.0,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 11.0),
                              Text(
                                "\$${bottomStatistics != null && bottomStatistics['profit'] != null ? bottomStatistics['profit'] : 0}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 6.0),
                              Text(
                                "Profit",
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(height: 30.0),
                      // Container(
                      //   width: double.infinity,
                      //   height: 48.0,
                      //   constraints: BoxConstraints(maxWidth: 343.0),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(31.0),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.grey[300],
                      //         offset: Offset(0.0, 0.0), // (x,y)
                      //         blurRadius: 10.0,
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Image.asset(
                      //         "images/Group 270.png",
                      //         width: 48.0,
                      //       ),
                      //       SizedBox(width: 12.0),
                      //       Text(
                      //         "Custom designs",
                      //         style: TextStyle(fontSize: 16.0),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        height: 48.0,
                        constraints: BoxConstraints(maxWidth: 343.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(31.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 0.0), // (x,y)
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "images/Group 268.png",
                              width: 48.0,
                            ),
                            SizedBox(width: 12.0),
                            Text(
                              "Get more customers",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 12.0),
                      // GestureDetector(
                      //   behavior: HitTestBehavior.translucent,
                      //   child: Container(
                      //     width: double.infinity,
                      //     height: 48.0,
                      //     constraints: BoxConstraints(maxWidth: 343.0),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(31.0),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey[300],
                      //           offset: Offset(0.0, 0.0), // (x,y)
                      //           blurRadius: 10.0,
                      //         ),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Image.asset(
                      //           "images/Group 268 (2).png",
                      //           width: 48.0,
                      //         ),
                      //         SizedBox(width: 12.0),
                      //         Stack(
                      //           clipBehavior: Clip.none,
                      //           children: [
                      //             Text(
                      //               "Confirm video",
                      //               style: TextStyle(fontSize: 16.0),
                      //             ),
                      //             Positioned(
                      //               top: -10,
                      //               right: -10,
                      //               child: Container(
                      //                 width: 14.0,
                      //                 height: 14.0,
                      //                 decoration: BoxDecoration(
                      //                   color: HexColor("#6092DC"),
                      //                   shape: BoxShape.circle,
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     "2",
                      //                     style: TextStyle(
                      //                       fontSize: 10.0,
                      //                       color: Colors.white,
                      //                       fontWeight: FontWeight.w700,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ConfirmVideo()),
                      //     );
                      //   },
                      // ),
                      SizedBox(height: 12.0),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
