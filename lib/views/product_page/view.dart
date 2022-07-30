import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/product_customization.dart';
import 'package:com.floridainc.dosparkles/widgets/swiper_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';

import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/product_page/action.dart';
import 'package:com.floridainc.dosparkles/views/product_page/state.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildView(
    ProductPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return _FirstPage(
    dispatch: dispatch,
    selectedProduct: state.selectedProduct,
    optionalMaterialSelected: state.optionalMaterialSelected,
    engraveInputs: state.engraveInputs,
    productQuantity: state.productQuantity,
  );
}

class _FirstPage extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  _FirstPage({
    this.dispatch,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
  });

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
        Scaffold(
          body: _MainBody(
            dispatch: widget.dispatch,
            selectedProduct: widget.selectedProduct,
            optionalMaterialSelected: widget.optionalMaterialSelected,
            engraveInputs: widget.engraveInputs,
            productQuantity: widget.productQuantity,
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Product Details",
              style: TextStyle(
                fontSize: 22,
                color: HexColor("#53586F"),
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.enable('smcp')],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leadingWidth: 70.0,
            automaticallyImplyLeading: false,
            actions: [
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('cartpage');
                  },
                  child: Container(
                    width: 34.0,
                    height: 34.0,
                    margin: EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200],
                          offset: Offset(0.0, 0.0), // (x, y)
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            "images/Group 2424.svg",
                            color: HexColor("#B3C1F2"),
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
                                    widget.productQuantity.toString(),
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
            leading: Builder(
              builder: (context) => IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        offset: Offset(0.0, 0.0), // (x, y)
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "images/Group 934534.svg",
                      color: HexColor("#B3C1F2"),
                    ),
                  ),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: SparklesDrawer(),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: double.infinity,
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
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _MainBody extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;
  final int productQuantity;

  _MainBody({
    this.dispatch,
    this.selectedProduct,
    this.optionalMaterialSelected,
    this.engraveInputs,
    this.productQuantity,
  });

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  int currentTab = 0;
  int _touchSpinValue = 0;

  @override
  void initState() {
    super.initState();
    _touchSpinValue = widget.productQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: 0,
      onRefresh: () {
        Navigator.of(context).pushNamed(
          'storepage',
          arguments: {'listView': false},
        );
        Future<void> delayed = Future.delayed(const Duration(milliseconds: 1));
        return delayed;
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0.0, 0.0),
              child: child,
            );
          },
          animation: controller,
        );
      },
      child: GestureDetector(
        onVerticalDragEnd: (dragEndDetails) {
          if (dragEndDetails.primaryVelocity > 0) {
            // Page down

            Navigator.of(context).pushNamed(
              'storepage',
              arguments: {'listView': false},
            );
            Future<void> delayed =
                Future.delayed(const Duration(milliseconds: 1));
            return delayed;
          }
        },
        child: SingleChildScrollView(
          child: Column(
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
                                      text:
                                          "\$${widget.selectedProduct.oldPrice} ",
                                      style: TextStyle(
                                        color:
                                            HexColor("#53586F").withOpacity(.5),
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
                                        ProductPageActionCreator
                                            .onSetProductCount(
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
                                        ProductPageActionCreator
                                            .onSetProductCount(
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
            ],
          ),
        ),
      ),
    );
  }
}
