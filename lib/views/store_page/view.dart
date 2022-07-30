import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/store_page/action.dart';
import 'package:com.floridainc.dosparkles/views/store_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/bottom_nav_bar.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/product_customization.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/widgets/swiper_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Widget buildView(
    StorePageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);

  if (state.selectedStore != null &&
      state.selectedStore.products != null &&
      state.selectedStore.products.length > 0) {
    state.selectedStore.products.sort((ProductItem a, ProductItem b) {
      if (a.orderInList == null || b.orderInList == null) {
        return -1;
      }
      if (a.orderInList != null && b.orderInList != null) {
        return a.orderInList.compareTo(b.orderInList);
      }
      return null;
    });
  }

  return state.listView
      ? _FirstListPage(
          dispatch: dispatch,
          state: state,
        )
      : _FirstProductPage(
          dispatch: dispatch,
          state: state,
        );
}

class _FirstProductPage extends StatefulWidget {
  final Dispatch dispatch;
  final StorePageState state;

  const _FirstProductPage({
    this.dispatch,
    this.state,
  });

  @override
  __FirstProductPageState createState() => __FirstProductPageState();
}

class __FirstProductPageState extends State<_FirstProductPage> {
  bool _isLostConnection = false;
  bool _isAppBarEnabled = true;

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

  void _setIsAppBarEnabled(bool value) {
    setState(() {
      _isAppBarEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return Stack(
      children: [
        Scaffold(
          body: _ProductView(
            dispatch: widget.dispatch,
            store: widget.state.selectedStore,
            productIndex: widget.state.productIndex,
            selectedProduct: widget.state.selectedProduct,
            optionalMaterialSelected: widget.state.optionalMaterialSelected,
            engraveInputs: widget.state.engraveInputs,
            productQuantity: widget.state.productQuantity,
            setIsAppBarEnabled: _setIsAppBarEnabled,
          ),
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: !_isAppBarEnabled
              ? null
              : AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  // actions: [
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 16.0),
                  //     child: SvgPicture.asset("images/Share.svg"),
                  //   ),
                  // ],
                  leadingWidth: 70.0,
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
          // bottomNavigationBar: StreamBuilder(
          //   stream: fetchDataProcess(),
          //   builder: (_, snapshot) {
          //     return BottomNavBarWidget(
          //       prefsData: snapshot.data,
          //       initialIndex: 0,
          //       isTransparentBackground: true,
          //     );
          //   },
          // ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _FirstListPage extends StatefulWidget {
  final Dispatch dispatch;
  final StorePageState state;

  const _FirstListPage({this.dispatch, this.state});

  @override
  __FirstListPageState createState() => __FirstListPageState();
}

class __FirstListPageState extends State<_FirstListPage> {
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
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
              child: _MainBody(
                dispatch: widget.dispatch,
                store: widget.state.selectedStore,
              ),
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            ),
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                widget.state.selectedStore != null &&
                        widget.state.selectedStore.name != null
                    ? widget.state.selectedStore.name
                    : '',
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
      ),
    );
  }
}

class _MainBody extends StatelessWidget {
  final Dispatch dispatch;
  final StoreItem store;

  const _MainBody({this.dispatch, this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                ProductItem product = store.products[index];

                return InkWell(
                  child: Container(
                    // color: HexColor('#dfdada'),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0.0, 0.0), // (x, y)
                          blurRadius: 10.0,
                        ),
                      ],
                    ),

                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: product.thumbnailUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: product.thumbnailUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "images/image-not-found.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                        if (product.isNew)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: double.infinity,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  color: HexColor("#EB5757"),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "NEW",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 40.0,
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 13.0,
                                left: 10,
                                right: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: HexColor("#0F142B").withOpacity(.7),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                product.name != null ? product.name : '',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    dispatch(
                      StorePageActionCreator.onProductIndexSelected(index),
                    );
                  },
                );
              },
              childCount: store != null && store.products != null
                  ? store.products.length
                  : 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductView extends StatefulWidget {
  final Dispatch dispatch;
  final AnimationController animationController;
  final StoreItem store;
  final int productIndex;

  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;
  final Function setIsAppBarEnabled;

  final globalUser = GlobalStore.store.getState().user;

  _ProductView({
    Key key,
    this.animationController,
    this.dispatch,
    this.store,
    this.productIndex,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
    this.setIsAppBarEnabled,
  }) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<_ProductView>
    with SingleTickerProviderStateMixin {
  List<GlobalKey<BetterPlayerPlaylistState>> _betterPlayerPlaylistStateKeys =
      List.empty(growable: true);
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  TabController _tabController;
  PanelController _panelController;
  int _tabSelectedIndex = 0;
  int _currentProductVideo = 0;
  bool _shouldAbsorb = true;
  bool _isDraggable = false;
  List<BetterPlayerDataSource> _dataSourceList = [];

  final double _initFabHeight = 50.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 0;

  BetterPlayerConfiguration _betterPlayerConfiguration;
  BetterPlayerPlaylistConfiguration _betterPlayerPlaylistConfiguration;
  BetterPlayerPlaylistController get _betterPlayerPlaylistController =>
      _betterPlayerPlaylistStateKeys[_tabSelectedIndex]
          .currentState
          .betterPlayerPlaylistController;

  bool isShowPlaying = false;

  BetterPlayerCacheConfiguration cacheConfiguration =
      BetterPlayerCacheConfiguration(
    useCache: true,
    maxCacheSize: 512 * 1024 * 1024,
    maxCacheFileSize: 512 * 1024 * 1024,
  );

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;

    for (int i = 0; i < widget.store.products.length; i++) {
      _betterPlayerPlaylistStateKeys
          .add(GlobalKey<BetterPlayerPlaylistState>());
    }

    GlobalStore.store.dispatch(GlobalActionCreator.setSelectedProduct(
        widget.store.products[widget.productIndex]));

    _panelController = PanelController();

    _tabController = TabController(
      length: widget.store.products.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _tabSelectedIndex = _tabController.index;
      });
    });

    _betterPlayerConfiguration = BetterPlayerConfiguration(
      showPlaceholderUntilPlay: true,
      autoPlay: true,
      aspectRatio: 9 / 16,
      controlsConfiguration:
          BetterPlayerControlsConfiguration(showControls: false),
    );
    _betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: true,
      nextVideoDelay: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerPlaylistController.dispose();
    _tabController.dispose();
  }

  void resetInformation(List<ProductItem> items) {
    _currentProductVideo = 0;
    if (mounted) setState(() {});

    List<BetterPlayerDataSource> arrayList = [];
    List<BetterPlayerDataSource> listArray = [];

    for (int i = 0; i < items[_tabSelectedIndex].videoUrls.length; i++) {
      String asset = items[_tabSelectedIndex].videoUrls[i];

      arrayList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          asset,
          cacheConfiguration: cacheConfiguration,
          placeholder: Container(),
        ),
      );
    }

    for (int i = 0; i < arrayList.length; i++) {
      BetterPlayerDataSource item = arrayList[i];

      if (!item.url.contains('.mp4')) {
        listArray.add(item.copyWith(
          placeholder: CachedNetworkImage(
            imageUrl: item.url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ));

        continue;
      }

      listArray.add(item);
    }

    _betterPlayerPlaylistController.betterPlayerController.pause();
    _dataSourceList.clear();
    _dataSourceList.addAll(listArray);
    _betterPlayerPlaylistController.setupDataSource(_currentProductVideo);
  }

  void setMediaList(List<ProductItem> items) async {
    _dataSourceList.clear();

    List<BetterPlayerDataSource> arrayList = [];

    for (int i = 0; i < items[_tabSelectedIndex].videoUrls.length; i++) {
      String asset = items[_tabSelectedIndex].videoUrls[i];

      arrayList.add(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          asset,
          cacheConfiguration: cacheConfiguration,
          placeholder: Container(),
        ),
      );
    }

    for (int i = 0; i < arrayList.length; i++) {
      BetterPlayerDataSource item = arrayList[i];

      if (!item.url.contains('.mp4')) {
        _dataSourceList.add(item.copyWith(
          placeholder: CachedNetworkImage(
            imageUrl: item.url,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ));

        continue;
      }

      _dataSourceList.add(item);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height;

    List<ProductItem> items = List.empty(growable: true);

    for (int i = widget.productIndex; i < widget.store.products.length; i++) {
      items.add(widget.store.products[i]);
    }
    for (int i = 0; i < widget.productIndex; i++) {
      items.add(widget.store.products[i]);
    }

    setMediaList(items);

    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SlidingUpPanel(
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          controller: _panelController,
          isDraggable: _isDraggable,
          onPanelOpened: () {
            _betterPlayerPlaylistController.betterPlayerController.pause();
            widget.setIsAppBarEnabled(false);
          },
          onPanelClosed: () {
            _betterPlayerPlaylistController.betterPlayerController.play();
            widget.setIsAppBarEnabled(true);
          },
          panelBuilder: (sc) => MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: () {
                final Completer<void> completer = Completer<void>();
                Timer(Duration(milliseconds: 1), () {
                  completer.complete();
                });
                return completer.future.then<void>((_) {
                  _panelController.close();
                });
              },
              height: 0.0,
              springAnimationDurationInMilliseconds: 1,
              showChildOpacityTransition: false,
              child: ListView(
                controller: sc,
                shrinkWrap: true,
                children: [
                  _BottomPanelWidget(
                    dispatch: widget.dispatch,
                    selectedProduct: widget.selectedProduct,
                    optionalMaterialSelected: widget.optionalMaterialSelected,
                    engraveInputs: widget.engraveInputs,
                    productQuantity: widget.productQuantity,
                  ),
                ],
              ),
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          onPanelSlide: (double pos) {
            setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            });
          },
          body: GestureDetector(
            // Using the DragEndDetails allows us to only fire once per swipe.
            onVerticalDragEnd: (dragEndDetails) {
              if (dragEndDetails.primaryVelocity < 0) {
                // Page up

                _panelController.open();
              } else if (dragEndDetails.primaryVelocity > 0) {
                // Page down
                widget.dispatch(StorePageActionCreator.onBackToAllProducts());
              }
            },
            onHorizontalDragEnd: (dragEndDetails) {
              if (dragEndDetails.primaryVelocity < 0) {
                // Page forwards

                if (_tabController.index < items.length - 1 &&
                    _tabSelectedIndex < items.length - 1) {
                  _tabController.index += 1;

                  GlobalStore.store.dispatch(
                      GlobalActionCreator.setSelectedProduct(
                          items[_tabController.index]));

                  resetInformation(items);
                } else {
                  _tabController.index = 0;

                  GlobalStore.store.dispatch(
                      GlobalActionCreator.setSelectedProduct(
                          items[_tabController.index]));

                  resetInformation(items);
                }
              } else if (dragEndDetails.primaryVelocity > 0) {
                // Page backwards

                if (_tabController.index == 0 && _tabController.offset == 0.0) {
                  widget.dispatch(StorePageActionCreator.onBackToAllProducts());
                  return;
                }

                if (_tabController.index >= 0 && _tabSelectedIndex >= 0) {
                  _tabController.index -= 1;
                  GlobalStore.store.dispatch(
                      GlobalActionCreator.setSelectedProduct(
                          items[_tabController.index]));
                  resetInformation(items);
                }
              }
            },
            onTap: () {
              if (_currentProductVideo <
                  items[_tabSelectedIndex].videoUrls.length - 1) {
                _currentProductVideo += 1;
              } else {
                _currentProductVideo = 0;
              }

              if (items[_tabSelectedIndex].videoUrls.length > 1) {
                _betterPlayerPlaylistController
                    .setupDataSource(_currentProductVideo);
              }

              if (mounted) setState(() {});

              // List<int> idsArray = List.empty(growable: true);
              // int currentIndex = _tabSelectedIndex;
              // ProductItem currentProduct = items[currentIndex];

              // for (int i = 0; i < items.length; i++) {
              //   if (items[i].id == currentProduct.id) {
              //     currentIndex = i;
              //   }
              // }

              // List<ProductItem> sameProducts = items
              //     .where((ProductItem product) =>
              //         product.shineonImportId == currentProduct.shineonImportId)
              //     .toList()
              //     .where((el) => el.id != currentProduct.id)
              //     .toList();

              // for (int i = 0; i < items.length; i++) {
              //   for (int j = 0; j < sameProducts.length; j++) {
              //     if (items[i].id == sameProducts[j].id) {
              //       idsArray.add(i);
              //     }
              //   }
              // }

              // List<int> moreThanCurrentIdx =
              //     idsArray.where((el) => el > currentIndex).toList();

              // if (idsArray.isNotEmpty) {
              //   if (moreThanCurrentIdx.isNotEmpty) {
              //     setState(() {
              //       _tabController.index = moreThanCurrentIdx[0];
              //       _tabSelectedIndex = moreThanCurrentIdx[0];
              //     });
              //   } else {
              //     setState(() {
              //       _tabController.index = idsArray[0];
              //       _tabSelectedIndex = idsArray[0];
              //     });
              //   }
              // }
            },

            child: AbsorbPointer(
              absorbing: _shouldAbsorb,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(items.length, (index) {
                  return items[index] != null &&
                          items[index].videoUrls != null &&
                          items[index].videoUrls.length > 0
                      ? Center(
                          child: RotatedBox(
                            quarterTurns: 0,
                            child: Container(
                              height: size.height,
                              width: size.width,
                              child: Container(
                                height: size.height,
                                width: size.width,
                                child: Stack(
                                  children: [
                                    SizedBox.expand(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          height: size.height,
                                          width: size.width,
                                          child: BetterPlayerPlaylist(
                                            key: _betterPlayerPlaylistStateKeys[
                                                index],
                                            betterPlayerConfiguration:
                                                _betterPlayerConfiguration,
                                            betterPlayerPlaylistConfiguration:
                                                _betterPlayerPlaylistConfiguration,
                                            betterPlayerDataSourceList:
                                                _dataSourceList,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container();
                }),
              ),
            ),
          ),
        ),

        // the fab
        Positioned(
          right: 15.0,
          bottom: _fabHeight,
          child: Container(
            width: 40.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: widget.globalUser.avatarUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.globalUser.avatarUrl),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage("images/user-male-circle.png"),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 30.0),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Image.asset("images/Vector 23423432.png"),
                //     SizedBox(height: 6.5),
                //     Text(
                //       "4020",
                //       style: TextStyle(
                //         fontSize: 10.0,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 25.0),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Image.asset("images/Group 2342342.png"),
                //     SizedBox(height: 6.5),
                //     Text(
                //       "234",
                //       style: TextStyle(
                //         fontSize: 10.0,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ],
                // ),
                //  SizedBox(height: 15.0),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, Animation animation,
                            Animation secondaryAnimation) {
                          return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.bottomCenter,
                            child: ProductCustomization(
                              dispatch: widget.dispatch,
                              selectedProduct: widget.selectedProduct,
                              productQuantity: widget.productQuantity,
                              engraveInputs: widget.engraveInputs,
                              optionalMaterialSelected:
                                  widget.optionalMaterialSelected,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("images/Vector (1)4234234.png"),
                      SizedBox(height: 6.5),
                      Text(
                        "BUY",
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
    );
  }
}

class _BottomPanelWidget extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  _BottomPanelWidget({
    this.dispatch,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
  });

  @override
  __BottomPanelWidgetState createState() => __BottomPanelWidgetState();
}

class __BottomPanelWidgetState extends State<_BottomPanelWidget> {
  int currentTab = 0;
  int _touchSpinValue = 0;

  @override
  void initState() {
    super.initState();
    _touchSpinValue = widget.productQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.0),
        SwiperWidget(productMedia: widget.selectedProduct.mediaUrls),
        SizedBox(height: 21.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 80.0,
              height: 64.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Group 12231221.svg",
                  width: 70.0,
                  height: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: 80.0,
              height: 64.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Group 123.svg",
                  width: 70.0,
                  height: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: 80.0,
              height: 64.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [HexColor('#E3D3FF'), HexColor('#C2A2FA')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "images/Group 126.svg",
                  width: 70.0,
                  height: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 19.0),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HexColor("#FAFCFF"),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32.0),
              topLeft: Radius.circular(32.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(0.0, -0.2), // (x, y)
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 19.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 37.0),
                child: Text(
                  "${widget.selectedProduct.name}",
                  style: TextStyle(
                    color: HexColor("#53586F"),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 21.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 37.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: "\$${widget.selectedProduct.oldPrice} ",
                                style: TextStyle(
                                  color: HexColor("#53586F").withOpacity(.5),
                                  fontSize: 18.0,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text: "\$${widget.selectedProduct.price}",
                                style: TextStyle(
                                  color: HexColor("#53586F"),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          "You Save: \$40 (50%)",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: HexColor("#27AE60"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 104.0,
                      height: 34.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.remove,
                              size: 22.0,
                              color: HexColor("#53586F"),
                            ),
                            onTap: () {
                              if (_touchSpinValue > 1) {
                                setState(() => _touchSpinValue--);

                                widget.dispatch(
                                  StorePageActionCreator.onSetProductCount(
                                    _touchSpinValue.toInt(),
                                  ),
                                );
                              }
                            },
                          ),
                          Text(
                            "$_touchSpinValue",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.add,
                              size: 22.0,
                              color: HexColor("#53586F"),
                            ),
                            onTap: () {
                              if (_touchSpinValue < 100) {
                                setState(() => _touchSpinValue++);

                                widget.dispatch(
                                  StorePageActionCreator.onSetProductCount(
                                    _touchSpinValue.toInt(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: double.infinity,
                        height: 36.0,
                        constraints: BoxConstraints(
                          maxWidth: 188.0,
                        ),
                        decoration: currentTab == 0
                            ? BoxDecoration(
                                color: HexColor("#FAFCFF"),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0.0, 5.0), // (x, y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              )
                            : null,
                        child: Center(
                          child: Text(
                            "Product Details",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: currentTab == 0
                                  ? HexColor("#53586F")
                                  : HexColor("#C4C6D2"),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentTab = 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: double.infinity,
                        height: 36.0,
                        constraints: BoxConstraints(
                          maxWidth: 188.0,
                        ),
                        decoration: currentTab == 1
                            ? BoxDecoration(
                                color: HexColor("#FAFCFF"),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    offset: Offset(0.0, 5.0), // (x, y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                              )
                            : null,
                        child: Center(
                          child: Text(
                            "Delivery Time",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: currentTab == 1
                                  ? HexColor("#53586F")
                                  : HexColor("#C4C6D2"),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentTab = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              currentTab == 1
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: HtmlWidget(
                        widget.selectedProduct.productDetails != null
                            ? widget.selectedProduct.productDetails
                            : "",
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: HtmlWidget(
                        widget.selectedProduct.deliveryTime != null
                            ? widget.selectedProduct.deliveryTime
                            : "",
                      ),
                    ),
              SizedBox(height: 35.0),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          constraints: BoxConstraints(maxHeight: 90.0),
          padding: EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.9),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 163.0,
                height: 42.0,
                child: Center(
                  child: Text(
                    "\$${widget.productQuantity * widget.selectedProduct.price}",
                    style: TextStyle(
                      color: HexColor("#53586F"),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 163.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor:
                            MaterialStateProperty.all(HexColor("#6092DC")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset("images/Group 423423.svg"),
                          SizedBox(width: 4.0),
                          Text(
                            'Add to cart',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return ScaleTransition(
                                scale: animation,
                                alignment: Alignment.bottomCenter,
                                child: ProductCustomization(
                                  dispatch: widget.dispatch,
                                  selectedProduct: widget.selectedProduct,
                                  productQuantity: widget.productQuantity,
                                  engraveInputs: widget.engraveInputs,
                                  optionalMaterialSelected:
                                      widget.optionalMaterialSelected,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
