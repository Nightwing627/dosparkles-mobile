import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/order_product_details.dart';
import 'package:com.floridainc.dosparkles/widgets/sparkles_drawer.dart';
import 'package:com.floridainc.dosparkles/widgets/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class OrderWidget extends StatefulWidget {
  final orderId;
  final Function setOrderChanged;

  const OrderWidget({
    Key key,
    this.orderId,
    this.setOrderChanged,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
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

  double allProductsTotalPrice = 0.0;

  Future getInitialData() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    var order = result.data['orders'][0];
    return order;
  }

  Future<void> getOrderTotalPrice() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    var order = result.data['orders'][0];

    if (order != null && order['totalPrice'] != null) {
      setState(() {
        allProductsTotalPrice = double.parse(order['totalPrice'].toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOrderTotalPrice();
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
            appBar: AppBar(
              title: Text(
                "Details of order",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFeatures: [FontFeature.enable('smcp')],
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leadingWidth: 70.0,
              automaticallyImplyLeading: false,
              leading: InkWell(
                child: Image.asset("images/back_button_white.png"),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: HexColor("#FAFCFF"),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: FutureBuilder(
                future: getInitialData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    var order = snapshot.data;
                    List<dynamic> products = order['products'];

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: products.length,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                var product = products[index];
                                List orderDetails = order != null &&
                                        order['orderDetails'] != null &&
                                        order['orderDetails'].length > 0
                                    ? order['orderDetails']
                                    : [];
                                Map orderDetail = orderDetails[index] ?? {};

                                if (product != null) {
                                  return InkWell(
                                    child: Card(
                                      elevation: 5.0,
                                      margin: EdgeInsets.only(bottom: 16.0),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shadowColor: Colors.black26,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        side:
                                            BorderSide(color: Colors.grey[50]),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 111.0,
                                        constraints:
                                            BoxConstraints(maxWidth: 343.0),
                                        padding: EdgeInsets.all(10.0),
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
                                                      BorderRadius.circular(
                                                          16.0),
                                                  child: product['thumbnail'] !=
                                                          null
                                                      ? CachedNetworkImage(
                                                          imageUrl: AppConfig
                                                                  .instance
                                                                  .baseApiHost +
                                                              product['thumbnail']
                                                                  ['url'],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        )
                                                      : SizedBox.shrink(
                                                          child: null),
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
                                                      product['name'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color:
                                                            HexColor("#53586F"),
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: product[
                                                                        'price'] !=
                                                                    null
                                                                ? "\$${product['price']} "
                                                                : ' ',
                                                            style: TextStyle(
                                                              fontSize: 22.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: HexColor(
                                                                  "#53586F"),
                                                            ),
                                                          ),
                                                          if (orderDetail !=
                                                                  null &&
                                                              orderDetail[
                                                                      'quantity'] !=
                                                                  null)
                                                            TextSpan(
                                                              text:
                                                                  "x${order['orderDetails'][index]['quantity']}",
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: HexColor(
                                                                    "#53586F"),
                                                              ),
                                                            )
                                                          else
                                                            TextSpan(
                                                              text: "x1",
                                                              style: TextStyle(
                                                                fontSize: 16.0,
                                                                color: HexColor(
                                                                    "#53586F"),
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
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            if (order['status'] ==
                                                'cancelled') {
                                              return _ChangeOrder(
                                                product: product,
                                                orderDetail:
                                                    order['orderDetails']
                                                        [index],
                                                order: order,
                                                setOrderChanged:
                                                    widget.setOrderChanged,
                                              );
                                            }
                                            return OrderProductDetailsWidget(
                                              product: product,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return SizedBox.shrink(child: null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Adapt.screenH() / 4),
                      SizedBox(
                        width: Adapt.screenW(),
                        height: Adapt.screenH() / 4,
                        child: Container(
                          child: CircularProgressIndicator(),
                          alignment: Alignment.center,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: Container(
              height: 83.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, -0.2), // (x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "TOTAL PRICE:",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\$$allProductsTotalPrice",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLostConnection) ConnectionLost(),
        ],
      ),
    );
  }
}

class _ChangeOrder extends StatefulWidget {
  final product;
  final orderDetail;
  final order;
  final Function setOrderChanged;

  const _ChangeOrder({
    Key key,
    this.product,
    this.orderDetail,
    this.order,
    this.setOrderChanged,
  }) : super(key: key);

  @override
  __ChangeOrderState createState() => __ChangeOrderState();
}

class __ChangeOrderState extends State<_ChangeOrder> {
  int currentTab = 0;
  List<Asset> pickedImages = <Asset>[];
  String engravingName = '';
  bool isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: widget.product['properties']['buyer_uploads'],
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
  Widget build(BuildContext context) {
    var productMedia = widget.product['media'].map((item) {
      return AppConfig.instance.baseApiHost + item['url'].toString();
    }).toList();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            "Change Order",
            style: TextStyle(
              fontSize: 22,
              color: HexColor("#53586F"),
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.enable('smcp')],
            ),
          ),
        ),
        drawer: SparklesDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              SwiperWidget(productMedia: productMedia),
              SizedBox(height: 16.0),
              Container(
                height: 71.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: pickedImages != null && pickedImages.length > 0
                    ? buildGridView(
                        pickedImages,
                        widget.product['properties']['buyer_uploads'],
                        loadAssets,
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.asset(
                                    "images/image 2.png",
                                    width: 70.0,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    width: 70.0,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white.withOpacity(.4),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: SvgPicture.asset(
                                      "images/cloud_white.svg",
                                      color: Colors.white,
                                      width: 24.0,
                                      height: 18.0,
                                      fit: BoxFit.cover,
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
                                  SizedBox(height: 2.0),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Files should be ",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: HexColor("#C4C6D2"),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "PNG, JPG ",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: HexColor("#53586F")
                                                .withOpacity(.7),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "size - 0000",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: HexColor("#C4C6D2"),
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
                        onTap: () {
                          if (widget.product['uploadsAvailable'] == true) {
                            loadAssets();
                          }
                        },
                      ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Engraving".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: HexColor("#C4C6D2"),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 40.0,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: HexColor("#EDEEF2"),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onChanged: (text) {
                    engravingName = text;
                  },
                  style: TextStyle(
                    color: HexColor("#53586F"),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Engraving name',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 16,
                    ),
                    fillColor: Colors.white,
                    hintStyle: new TextStyle(color: Colors.grey),
                    labelStyle: new TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Container(
                  width: 300.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled))
                            return HexColor("#C4C6D2");
                          return HexColor("#6092DC");
                        },
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? Container(
                            width: 25.0,
                            height: 25.0,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            await _onSaveClicked(
                              context,
                              widget.product['id'],
                              pickedImages,
                              engravingName,
                              widget.product['properties']['buyer_uploads'],
                              _setLoading,
                              widget.order,
                              widget.orderDetail,
                              widget.setOrderChanged,
                            );
                          },
                  ),
                ),
              ),
              SizedBox(height: 18.0),
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
                        "${widget.product['name']}",
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
                          child: InkWell(
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
                          child: InkWell(
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
        ),
      ),
    );
  }
}

Future _sendRequest(imagesList) async {
  Uri uri = Uri.parse('https://backend.dosparkles.com/upload');

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

Widget buildGridView(List<Asset> images, int buyUploads, Function loadAssets) {
  int diff = buyUploads - images.length;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var asset in images)
          Container(
            width: 70.0,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AssetThumb(asset: asset, width: 300, height: 300),
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
        for (int i = 0; i < diff; i++)
          Container(
            width: 70.0,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Card(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(Icons.add),
            ),
          ),
      ],
    ),
    onTap: () {
      loadAssets();
    },
  );
}

Future<void> _onSaveClicked(
  BuildContext context,
  productId,
  pickedImages,
  String engravingName,
  buyerUploads,
  Function _setLoading,
  order,
  Map orderDetail,
  Function setOrderChanged,
) async {
  if (pickedImages != null && pickedImages.length > 0) {
    _setLoading(true);
    try {
      List<String> listOfIds = await _sendRequest(pickedImages);

      QueryResult resultFetch =
          await BaseGraphQLClient.instance.fetchProductById(productId);

      var product = resultFetch.data['products'][0];
      List<String> listOfMediaIds = [];

      for (int i = 0; i < product['media'].length; i++) {
        listOfMediaIds.add("\"${product['media'][i]['id']}\"");
      }

      await BaseGraphQLClient.instance
          .updateProductMedia(productId, [...listOfMediaIds, ...listOfIds]);

      setOrderChanged(true);

      int count = 2;
      Navigator.of(context).popUntil((_) => count-- <= 0);

      _setLoading(false);
    } catch (e) {
      print(e);
    }
  }

  if (engravingName != null && engravingName != '') {
    _setLoading(true);
    try {
      orderDetail['properties']['Custom_Engraving'] = engravingName;

      List mergedList = [orderDetail];

      jsonEncode(mergedList);

      QueryResult result = await BaseGraphQLClient.instance
          .updateOrderEngravingName(order['id'], mergedList);

      setOrderChanged(true);

      int count = 2;
      Navigator.of(context).popUntil((_) => count-- <= 0);

      _setLoading(false);
    } catch (e) {
      print(e);
    }
  }
}
