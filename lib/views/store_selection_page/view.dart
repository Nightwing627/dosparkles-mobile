import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/views/store_selection_page/action.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
  StoreSelectionPageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);

  return _MainBodyPage(dispatch: dispatch);
}

class _MainBodyPage extends StatefulWidget {
  final Dispatch dispatch;

  const _MainBodyPage({this.dispatch});

  @override
  __MainBodyPageState createState() => __MainBodyPageState();
}

class __MainBodyPageState extends State<_MainBodyPage> {
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
            child: _InnerPart(dispatch: widget.dispatch),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Choose your school",
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
          drawer: SparklesDrawer(activeRoute: "homepage"),
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

class _InnerPart extends StatefulWidget {
  final stores = GlobalStore.store.getState().storesList;
  final Dispatch dispatch;

  _InnerPart({Key key, this.dispatch}) : super(key: key);

  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  List<StoreItem> filteredList;
  String searchValue = "";

  void _onSearch() {
    if (widget.stores != null && mounted) {
      setState(() {
        filteredList = widget.stores.where((contact) {
          String name = contact.name.toLowerCase();
          String value = searchValue.toLowerCase();
          return name.indexOf(value) != -1;
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("widget.stores");
    print(widget.stores);
    try {
    if (widget.stores != null && widget.stores.length > 0) {
      widget.stores.sort((StoreItem a, StoreItem b) {
        if (a.storeDistance != null && b.storeDistance != null && a.storeDistance != "null" && b.storeDistance != "null") {
          return a.storeDistance.compareTo(b.storeDistance);
        }
        return null;
      });
    }
    }catch(e) {
         print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var relevantList = filteredList != null && filteredList.length > 0
        ? filteredList
        : widget.stores;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: HexColor("#EDEEF2"),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                ),
                child: TextField(
                  onChanged: (text) {
                    searchValue = text;
                  },
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.78,
              ),
              InkWell(
                child: Container(
                  width: 45,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: HexColor("#6092DC"),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  _onSearch();
                },
              )
            ],
          ),
          SizedBox(height: 17.0),
          Expanded(
            child: relevantList != null && relevantList.length > 0
                ? ListView.separated(
                    itemCount: relevantList.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Card(
                          elevation: 5.0,
                          shadowColor: Colors.grey[50].withOpacity(.5),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 85.0,
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 73.0,
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: relevantList[index].thumbnail != null
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                relevantList[index].thumbnail,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Image.asset(
                                            "images/image-not-found.png",
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          relevantList[index].name,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5.0),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 15.0,
                                          child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              SvgPicture.asset(
                                                "images/Group 2131.svg",
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 15.0,
                                                child: Text(
                                                  relevantList[index].address,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 16.0,
                                          child: Stack(
                                            alignment: Alignment.centerLeft,
                                            children: [
                                              SvgPicture.asset(
                                                "images/Group (1).svg",
                                              ),
                                              Positioned(
                                                top: 0,
                                                left: 15.0,
                                                child: Text(
                                                  relevantList[index].phone,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
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
                        onTap: () {
                          widget.dispatch(
                            StoreSelectionPageActionCreator.onStoreSelected(
                              relevantList[index],
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
