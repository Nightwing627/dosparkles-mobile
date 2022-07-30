import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/widgets/swiper_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class OrderProductDetailsWidget extends StatefulWidget {
  final product;

  const OrderProductDetailsWidget({Key key, this.product}) : super(key: key);

  @override
  _OrderProductDetailsWidgetState createState() =>
      _OrderProductDetailsWidgetState();
}

class _OrderProductDetailsWidgetState extends State<OrderProductDetailsWidget> {
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
            product: widget.product,
          ),
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
            backgroundColor: Colors.white,
            title: Text(
              "Details of product",
              style: TextStyle(
                fontSize: 22,
                color: HexColor("#53586F"),
                fontWeight: FontWeight.w600,
                fontFeatures: [FontFeature.enable('smcp')],
              ),
            ),
          ),
          drawer: SparklesDrawer(),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}

class _MainBody extends StatefulWidget {
  final product;

  _MainBody({this.product});

  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
  var productMedia;
  int currentTab = 0;
  int selectedImage = 0;

  @override
  void initState() {
    super.initState();

    productMedia = widget.product['media']
        .map(
          (item) => AppConfig.instance.baseApiHost + item['url'].toString(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          SwiperWidget(
            productMedia: productMedia,
            selectedImage: selectedImage,
          ),
          SizedBox(height: 21.0),
          Container(
            height: 70.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(width: 14.0),
              itemCount: productMedia.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    InkWell(
                      child: Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 4.0), // (x, y)
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: productMedia[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedImage = index;
                        });
                      },
                    ),
                    index == selectedImage
                        ? Positioned.fill(
                            child: Container(
                              width: 70.0,
                              height: 70.0,
                              color: Colors.white.withOpacity(.4),
                            ),
                          )
                        : SizedBox.shrink(child: null),
                  ],
                );
              },
            ),
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
                    widget.product['name'],
                    style: TextStyle(
                      color: HexColor("#53586F"),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 21.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "\$${widget.product['price']} ",
                            style: TextStyle(
                              color: HexColor("#53586F"),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "\$${widget.product['oldPrice']}",
                            style: TextStyle(
                              color: HexColor("#53586F").withOpacity(.5),
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
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
                          widget.product['productDetails'] != null
                              ? widget.product['productDetails']
                              : '',
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: HtmlWidget(
                          widget.product['deliveryTime'] != null
                              ? widget.product['deliveryTime']
                              : '',
                        ),
                      ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomBody extends StatefulWidget {
  final product;

  _CustomBody({this.product});

  @override
  __CustomBodyState createState() => __CustomBodyState();
}

class __CustomBodyState extends State<_CustomBody> {
  var productMedia;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();

    productMedia = widget.product['media']
        .map(
          (item) => AppConfig.instance.baseApiHost + item['url'].toString(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          SwiperWidget(productMedia: productMedia),
          SizedBox(height: 16.0),
          Container(
            height: 71.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        "images/image 2.png",
                        fit: BoxFit.cover,
                        width: 70.0,
                        height: double.infinity,
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
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "your Uploaded image".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "your metal".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        height: 40.0,
                        constraints: BoxConstraints(
                          maxWidth: 155.0,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor("#CCD4FE"),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: HexColor("#B3C1F2")),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 0.0), // (x,y)
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42.5,
                                  height: 42.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      "images/image 535435.png",
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.5),
                                Text(
                                  "Stainless",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: HexColor("#53586F"),
                                  ),
                                ),
                              ],
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
                    ],
                  ),
                ),
                SizedBox(width: 11.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Engraving".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: HexColor("#C4C6D2"),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        height: 40.0,
                        constraints: BoxConstraints(
                          maxWidth: 155.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: HexColor("#CCD4FE"),
                          border: Border.all(color: HexColor("#B3C1F2")),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 0.0), // (x,y)
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "Engraving name",
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
                    ],
                  ),
                ),
              ],
            ),
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
                    "${widget.product['name']} ",
                    style: TextStyle(
                      color: HexColor("#53586F"),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 21.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "\$${widget.product['price']} ",
                            style: TextStyle(
                              color: HexColor("#53586F"),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "\$${widget.product['oldPrice']} ",
                            style: TextStyle(
                              color: HexColor("#53586F").withOpacity(.5),
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
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
                          widget.product['productDetails'] != null
                              ? widget.product['productDetails']
                              : '',
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: HtmlWidget(
                          widget.product['deliveryTime'] != null
                              ? widget.product['deliveryTime']
                              : '',
                        ),
                      ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
