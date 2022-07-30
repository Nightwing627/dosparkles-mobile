import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/profile_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';

import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/custom_switch.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _switchNotifications(
  bool value,
  Function setSwitchLoading,
  Function setSwitchValue,
) async {
  AppUser globalUser = GlobalStore.store.getState().user;
  setSwitchLoading(true);

  try {
    QueryResult result = await BaseGraphQLClient.instance
        .setUserNotifications(globalUser.id, value);

    if (result.data != null) {
      setSwitchValue(value);
    }

    setSwitchLoading(false);
  } catch (e) {
    print(e);
  }
}

void _changeProfileMainImage(
    List<Asset> pickedImages, Function setLoading) async {
  AppUser globalUser = GlobalStore.store.getState().user;

  setLoading(true);
  List<String> listOfIds = await _sendRequest(pickedImages);

  QueryResult result = await BaseGraphQLClient.instance
      .setUserAvatar(globalUser.id, listOfIds[0]);

  globalUser.avatarUrl = AppConfig.instance.baseApiHost +
      result.data['updateUser']['user']['avatar']['url'];
  GlobalStore.store.dispatch(GlobalActionCreator.setUser(globalUser));

  setLoading(false);
}

Future _sendRequest(imagesList) async {
  Uri uri = Uri.parse('${AppConfig.instance.baseApiHost}/upload');

  MultipartRequest request = http.MultipartRequest("POST", uri);

  for (var i = 0; i < imagesList.length; i++) {
    var asset = imagesList[i];

    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    MultipartFile multipartFile = MultipartFile.fromBytes(
      'files',
      imageData,
      filename: '${asset.name}',
      contentType: MediaType("image", "jpg"),
    );

    request.files.add(multipartFile);
  }

  http.Response response = await http.Response.fromStream(await request.send());

  List imagesResponse = json.decode(response.body);
  List<String> listOfIds =
      imagesResponse.map((image) => "\"${image['id']}\"").toList();

  // List<Map<String, String>> imagesData = imagesResponse
  //     .map((image) => {'url': "${image['url']}", 'id': "${image['id']}"})
  //     .toList();

  return listOfIds;
}

Widget buildView(
    ProfilePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage();
}

class _FirstPage extends StatefulWidget {
  @override
  __FirstPageState createState() => __FirstPageState();
}

class __FirstPageState extends State<_FirstPage> {
  AppUser globalUser = GlobalStore.store.getState().user;
  bool _isLostConnection = false;

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
          drawer: SparklesDrawer(activeRoute: "profilepage"),
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
  final AppUser globalUser = GlobalStore.store.getState().user;

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  bool _switchValue = false;
  List<Asset> pickedImages = <Asset>[];
  bool _isLoading = false;
  bool _isSwitchLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _setSwitchLoading(bool value) {
    setState(() {
      _isSwitchLoading = value;
    });
  }

  void _setSwitchValue(bool value) {
    setState(() {
      _switchValue = value;
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

  @override
  void initState() {
    super.initState();

    if (widget.globalUser != null)
      BaseGraphQLClient.instance
          .fetchUserNotification(widget.globalUser.id)
          .then((result) {
        if (result.data != null && mounted) {
          setState(() {
            _switchValue = result.data['users'][0]['enableNotifications'];
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30.0),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Container(
                  width: 82.0,
                  height: 82.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
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
            onTap: () async {
              await loadAssets();
              if (pickedImages != null && pickedImages.length > 0) {
                _changeProfileMainImage(pickedImages, _setLoading);
              }
            },
          ),
          SizedBox(height: 12.0),
          Text(
            widget.globalUser != null && widget.globalUser.name != null
                ? widget.globalUser.name
                : "User",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("images/bell_icon.svg"),
                SizedBox(width: 11.33),
                Text(
                  "Notifcations",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Spacer(),
                Stack(
                  children: [
                    CustomSwitch(
                      value: _switchValue,
                      onChanged: (bool value) {
                        _switchNotifications(
                            value, _setSwitchLoading, _setSwitchValue);
                      },
                    ),
                    if (_isSwitchLoading)
                      Positioned.fill(
                        child: Container(
                          width: 54.0,
                          height: 26.0,
                          color: Colors.white.withOpacity(.8),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/Group 328.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Order History",
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
                  MaterialPageRoute(
                    builder: (context) => _OrderHistory(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 32.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/location_icon.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Change Default Store",
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
                Navigator.of(context)
                    .pushReplacementNamed('storeselectionpage');
              },
            ),
          ),
          SizedBox(height: 32.0),
          if (widget.globalUser.provider == 'local')
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("images/lock_icon.svg"),
                        SizedBox(width: 11.33),
                        Text(
                          "Change Password",
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
                      Navigator.of(context)
                          .pushNamed('forgot_passwordpage', arguments: null);
                    },
                  ),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("images/Group 32.svg"),
                  SizedBox(width: 11.33),
                  Text(
                    "Friends Signed Up",
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
                  MaterialPageRoute(
                    builder: (context) => _FriendsSignedUp(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }
}

class _OrderHistory extends StatefulWidget {
  final globalOrders = GlobalStore.store.getState().user.orders;

  @override
  __OrderHistoryState createState() => __OrderHistoryState();
}

class __OrderHistoryState extends State<_OrderHistory> {
  String selectedDate = DateTime.now().toString();
  List filteredList = [];

  String formatDateTimeToMY(String date) {
    if (date == null || date.length < 15) date = DateTime.now().toString();
    return DateFormat('LLLL yyyy').format(DateTime.parse(date));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.globalOrders != null && widget.globalOrders.length > 0) {
      filteredList = widget.globalOrders.where((order) {
        String orderformatted = formatDateTimeToMY(order['createdAt']);
        String selectedformatted = formatDateTimeToMY(selectedDate);
        return orderformatted == selectedformatted;
      }).toList();
    } else {
      filteredList = [];
    }

    selectedDate = formatDateTimeToMY(selectedDate);

    return Container(
      color: Colors.white,
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
            backgroundColor: Colors.white,
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
                "Order History",
                style: TextStyle(
                  fontSize: 22,
                  color: HexColor("#53586F"),
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
              ),
            ),
            body: Builder(builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.0),
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
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(0.0)),
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
                    SizedBox(height: 17.0),
                    if (filteredList != null && filteredList.length > 0)
                      Flexible(
                        fit: FlexFit.loose,
                        child: ListView.separated(
                          itemCount: filteredList.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.0),
                          itemBuilder: (context, index) {
                            var order = filteredList[index];

                            return Card(
                              elevation: 4.0,
                              shadowColor: Colors.grey[50].withOpacity(.5),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 13.0),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Text(
                                          "Order ID:",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Positioned(
                                          left: 104.0,
                                          child: Container(
                                            width: 180.0,
                                            child: Text(
                                              order['id'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.0),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Text(
                                          "Status:",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Positioned(
                                          left: 104.0,
                                          child: Container(
                                            child: Text(
                                              order['status'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: order['status'] ==
                                                        'cancelled'
                                                    ? Colors.red
                                                    : order['status'] ==
                                                            'confirmed'
                                                        ? Colors.green
                                                        : Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 11.0),
                                    order['products'] != null &&
                                            order['products'].length > 0
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      order['products'].length -
                                                          1;
                                                  i++)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 11.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 60.0,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 60.0,
                                                          height:
                                                              double.infinity,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            child: order['products']
                                                                            [i][
                                                                        'thumbnail'] !=
                                                                    null
                                                                ? CachedNetworkImage(
                                                                    imageUrl: AppConfig
                                                                            .instance
                                                                            .baseApiHost +
                                                                        order['products'][i]['thumbnail']
                                                                            [
                                                                            'url'],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                  )
                                                                : Image.asset(
                                                                    "images/image-not-found.png",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.0),
                                                        Expanded(
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  order['products']
                                                                          [i]
                                                                      ['name'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: HexColor(
                                                                        "#53586F"),
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        7.0),
                                                                RichText(
                                                                  text:
                                                                      TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text: order['products'][i]['price'] !=
                                                                                null
                                                                            ? "\$${order['products'][i]['price']} "
                                                                            : '',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              HexColor("#53586F"),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text: order['orderDetails'] != null &&
                                                                                order['orderDetails'].length > 0 &&
                                                                                order['orderDetails'][i]['quantity'] != null
                                                                            ? "x${order['orderDetails'][i]['quantity']}"
                                                                            : '',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.0,
                                                                          color:
                                                                              HexColor("#53586F"),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                            ],
                                          )
                                        : SizedBox.shrink(child: null),
                                    SizedBox(height: 11.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "TOTAL PRICE:",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "\$${order['totalPrice']}",
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 13.0),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Center(child: Text("No Data")),
                    SizedBox(height: 20.0),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FriendsSignedUp extends StatefulWidget {
  final AppUser globalUser = GlobalStore.store.getState().user;

  @override
  __FriendsSignedUpState createState() => __FriendsSignedUpState();
}

class __FriendsSignedUpState extends State<_FriendsSignedUp> {
  Future _fetchData() async {
    if (widget.globalUser != null) {
      QueryResult result =
          await BaseGraphQLClient.instance.fetchUserById(widget.globalUser.id);
      return result.data['users'][0];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
            backgroundColor: Colors.white,
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
                "Friends Signed Up",
                style: TextStyle(
                  fontSize: 22,
                  color: HexColor("#53586F"),
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              child: FutureBuilder(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    List invitesSent = snapshot.data['invitesSent'] != null
                        ? snapshot.data['invitesSent']
                            .where((el) => el['confirmed'] == true)
                            .toList()
                        : [];

                    return Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: invitesSent == null || invitesSent.length == 0
                          ? Center(child: Text("No Data"))
                          : SafeArea(
                              child: ListView.separated(
                                itemCount: invitesSent.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (_, index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 2.0,
                                    height: 0.0,
                                  ),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Map contact = invitesSent[index];

                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    color: HexColor("#FAFCFF"),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        FLAvatar(
                                          image: Image.asset(
                                            'images/user-male-circle.png',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                          width: 50.0,
                                          height: double.infinity,
                                        ),
                                        SizedBox(width: 13.0),
                                        Expanded(
                                          child: Text(
                                            "${contact['name'] != null ? contact['name'] : contact['phone']}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
