import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/cart_page/action.dart';
import 'package:com.floridainc.dosparkles/views/cart_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/checkout.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';

import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

Widget buildView(
    CartPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage(
    dispatch: dispatch,
    shoppingCart: state.shoppingCart,
  );
}

class _FirstPage extends StatefulWidget {
  final Dispatch dispatch;
  final List<CartItem> shoppingCart;

  const _FirstPage({this.dispatch, this.shoppingCart});

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
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _MainBody(
                dispatch: widget.dispatch,
                shoppingCart: widget.shoppingCart,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Cart",
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
            actions: [
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('cartpage');
                  },
                  child: Container(
                    width: 32.0,
                    height: 32.0,
                    margin: EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(.2),
                          offset: Offset(0.0, 0.0), // (x, y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            "images/Group 2424.svg",
                            color: Colors.white,
                          ),
                          Positioned.fill(
                            top: -2.5,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.shoppingCart.length.toString(),
                                    style: TextStyle(
                                      fontSize: 6.0,
                                      fontWeight: FontWeight.w900,
                                      color: HexColor("#6092DC"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: SparklesDrawer(),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;
  final List<CartItem> shoppingCart;

  const _MainBody({this.dispatch, this.shoppingCart});

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    for (var i = 0; i < widget.shoppingCart.length; i++) {
      totalAmount += widget.shoppingCart[i].amount;
    }

    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: () {
        final Completer<void> completer = Completer<void>();
        Timer(Duration(milliseconds: 1), () {
          completer.complete();
        });
        return completer.future.then<void>((_) {
          Navigator.of(context)
              .pushReplacementNamed('storepage', arguments: null);
        });
      },
      height: 0.0,
      springAnimationDurationInMilliseconds: 1,
      showChildOpacityTransition: false,
      child: GestureDetector(
        onVerticalDragEnd: (dragEndDetails) {
          if (dragEndDetails.primaryVelocity > 0) {
            // Page down
            Navigator.of(context)
                .pushReplacementNamed('storepage', arguments: null);
            Future<void> delayed =
                Future.delayed(const Duration(milliseconds: 1));
            return delayed;
          }
        },
        child: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Item in your cart is in high demand. Proceed to quickly to reserve.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: HexColor("#EB5757"),
                    ),
                  ),
                ),
                SizedBox(height: 26.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.shoppingCart
                      .asMap()
                      .map((index, value) {
                        return MapEntry(
                          index,
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 26.0,
                              right: 16.0,
                              left: 16.0,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 111.0,
                                  constraints: BoxConstraints(maxWidth: 343.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[200],
                                        offset: Offset(0.0, 3.0), // (x, y)
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 91.0,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 78.0,
                                          height: double.infinity,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            child: widget.shoppingCart[index]
                                                            .product !=
                                                        null &&
                                                    widget
                                                            .shoppingCart[index]
                                                            .product
                                                            .thumbnailUrl !=
                                                        null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                          .shoppingCart[index]
                                                          .product
                                                          .thumbnailUrl,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : SizedBox.shrink(child: null),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.shoppingCart != null &&
                                                        widget.shoppingCart[
                                                                index] !=
                                                            null &&
                                                        widget
                                                                .shoppingCart[
                                                                    index]
                                                                .product !=
                                                            null &&
                                                        widget
                                                                .shoppingCart[
                                                                    index]
                                                                .product
                                                                .name !=
                                                            null
                                                    ? widget.shoppingCart[index]
                                                        .product.name
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: HexColor("#53586F"),
                                                ),
                                              ),
                                              SizedBox(height: 12.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '\$${widget.shoppingCart[index].amount}',
                                                    style: TextStyle(
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          HexColor("#53586F"),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 104.0,
                                                    height: 34.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          HexColor("#FAFCFF"),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: 22.0,
                                                            color: HexColor(
                                                                "#53586F"),
                                                          ),
                                                          onTap: () {
                                                            int count = widget
                                                                .shoppingCart[
                                                                    index]
                                                                .count;

                                                            count--;

                                                            if (count >= 1) {
                                                              widget.dispatch(
                                                                CartPageActionCreator
                                                                    .onSetProductCount(
                                                                  widget.shoppingCart[
                                                                      index],
                                                                  count,
                                                                ),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          "${widget.shoppingCart[index].count}",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 22.0,
                                                            color: HexColor(
                                                                "#53586F"),
                                                          ),
                                                          onTap: () {
                                                            int count = widget
                                                                .shoppingCart[
                                                                    index]
                                                                .count;
                                                            count++;
                                                            if (count <= 100 &&
                                                                count >= 1) {
                                                              widget.dispatch(
                                                                CartPageActionCreator
                                                                    .onSetProductCount(
                                                                  widget.shoppingCart[
                                                                      index],
                                                                  count,
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  top: -13.0,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      child: Image.asset(
                                          "images/Component 16.png"),
                                      onTap: () {
                                        widget.dispatch(CartPageActionCreator
                                            .onRemoveCartItem(
                                                widget.shoppingCart[index]));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 120.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: HexColor("#CCD4FE"),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "images/Group 1232423.svg",
                          height: 79.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      width: 120.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: HexColor("#CCD4FE"),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "images/Group 123 (1).svg",
                          height: 79.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 27.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "TOTAL PRICE:",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: HexColor("#0F142B"),
                            ),
                          ),
                          Text(
                            "\$$totalAmount",
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w900,
                              color: HexColor("#0F142B"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Shipping calculated at checkout",
                        style: TextStyle(
                          color: HexColor("#0F142B"),
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
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
                            'Proceed To Checkout',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(
                                  dispatch: widget.dispatch,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
