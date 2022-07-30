import 'dart:ui';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:com.floridainc.dosparkles/widgets/details_of_order.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'state.dart';

Future<void> _sendPushNotification(String orderId, bool isApproved) async {
  if (orderId != null && orderId != '') {
    await http.post(
      '${AppConfig.instance.baseApiHost}/notifications/sendPushNotification',
      body: {
        'orderId': "$orderId",
        'status': "$isApproved",
      },
    );
  }
}

class _ChangeOrderButton extends StatefulWidget {
  final BuildContext context;
  final String orderId;

  _ChangeOrderButton({this.context, this.orderId});

  @override
  __ChangeOrderButtonState createState() => __ChangeOrderButtonState();
}

class __ChangeOrderButtonState extends State<_ChangeOrderButton> {
  bool isPublic = GlobalStore.store.getState().user.role == 'Public';
  bool _isOrderChanged = false;

  Future getInitialData() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);
    return result.data['orders'][0];
  }

  void refresh() {
    setState(() {});
  }

  void _setOrderChanged(bool value) {
    setState(() {
      _isOrderChanged = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialData(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data['status'] == 'cancelled' &&
            snapshot.data['rejectedReason'] != null &&
            snapshot.data['rejectedReason'] != "" &&
            isPublic) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 29.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isOrderChanged)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 100.0,
                          height: 30.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              elevation: MaterialStateProperty.all(0.0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Re-submit",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await BaseGraphQLClient.instance
                                    .changeOrder(widget.orderId, "on_hold", "");

                                refresh();
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  Container(
                    width: 120.0,
                    height: 30.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          HexColor("#27AE60"),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        elevation: MaterialStateProperty.all(0.0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Change order",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderWidget(
                              orderId: snapshot.data['id'],
                              setOrderChanged: _setOrderChanged,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return SizedBox.shrink(child: null);
      },
    );
  }
}

Widget buildView(
    ChatMessagesPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    BubblePage(
      chatId: state.chatId,
      userId: state.userId,
      conversationName: state.conversationName,
    )
  ];

  Widget _buildPage(Widget page) {
    return page;
  }

  return Scaffold(
    body: FutureBuilder(
        future: _checkContextInit(
          Stream<double>.periodic(Duration(milliseconds: 50),
              (x) => MediaQuery.of(viewService.context).size.height),
        ),
        builder: (_, snapshot) {
          if (snapshot.hasData) if (snapshot.data > 0) {
            Adapt.initContext(viewService.context);
            return PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: state.pageController,
              allowImplicitScrolling: false,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return _buildPage(pages[index]);
              },
            );
          }
          return Container();
        }),
  );
}

Future<double> _checkContextInit(Stream<double> source) async {
  await for (double value in source) {
    if (value > 0) {
      return value;
    }
  }
  return 0.0;
}

Future fetchData(String chatId) async {
  QueryResult chat = await BaseGraphQLClient.instance.fetchChat(chatId);

  return chat.data['chats'][0];
}

Stream fetchDataProcess(String chatId) async* {
  while (true) {
    yield await fetchData(chatId);
    await Future<void>.delayed(Duration(seconds: 30));
  }
}

class BubblePage extends StatefulWidget {
  final String chatId;
  final String userId;
  final String conversationName;

  const BubblePage({
    Key key,
    this.chatId = '',
    this.userId = '',
    this.conversationName = 'DoSparkles',
  }) : super(key: key);

  @override
  State<BubblePage> createState() => _BubblePageState();
}

class _BubblePageState extends State<BubblePage> {
  String inputData = "";
  var _controller = TextEditingController();
  bool _isLostConnection = false;

  getConversationName(conversation, userId) {
    var chatNames = [];
    var users = conversation['users'];
    for (int i = 0; i < users.length; i++) {
      if (users[i] != null && users[i]['id'] != userId) {
        chatNames.add('${users[i]['name']}');
      }
    }
    return chatNames.join(', ');
  }

  addMessage(text, chatId, userId) async {
    await BaseGraphQLClient.instance
        .createMessage({'text': text, 'chat': chatId, 'user': userId});
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
            appBar: AppBar(
              title: Text(
                widget.conversationName != null ? widget.conversationName : '',
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
              padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: HexColor("#FAFCFF"),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: Column(
                children: [
                  _BubbleContentWidget(
                    chatId: widget.chatId,
                    userId: widget.userId,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 83.0,
              padding: EdgeInsets.only(top: 10.0),
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
                children: [
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
                          controller: _controller,
                          onChanged: (text) {
                            this.inputData = text;
                          },
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter message',
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
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
                            Icons.send,
                            color: Colors.white,
                            size: 17.0,
                          ),
                        ),
                        onTap: () {
                          if (this.inputData != "") {
                            addMessage(
                              this.inputData,
                              widget.chatId,
                              widget.userId,
                            );
                            this.inputData = "";
                            _controller.clear();
                          }
                        },
                      )
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

class _ChatOrderBlock extends StatefulWidget {
  var formatter = new DateFormat.yMMMMd().add_jm();
  bool isAdmin = GlobalStore.store.getState().user.role == 'Store Manager';

  final orderId;
  final createdAt;

  _ChatOrderBlock({this.orderId, this.createdAt});

  @override
  __ChatOrderBlockState createState() => __ChatOrderBlockState();
}

class __ChatOrderBlockState extends State<_ChatOrderBlock> {
  bool isApproveClicked = false;

  Future getInitialData() async {
    QueryResult result =
        await BaseGraphQLClient.instance.fetchOrder(widget.orderId);

    return result.data['orders'][0];
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          var order = snapshot.data;
          bool isStatusRejected = order['status'] == 'cancelled';
          bool isStatusConfirmed = order['status'] == 'confirmed';

          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 300.0,
              height: isStatusRejected
                  ? 200.0
                  : widget.isAdmin && !isStatusConfirmed
                      ? 160.0
                      : 115.0,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.passthrough,
                children: [
                  widget.createdAt != null
                      ? Positioned(
                          bottom: -20.0,
                          left: 17.0,
                          child: Text(
                            '${widget.formatter.format(DateTime.parse(widget.createdAt))}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                        )
                      : '',
                  Bubble(
                    margin: BubbleEdges.only(top: 10),
                    elevation: 5.0,
                    shadowColor: Colors.grey[50].withOpacity(.5),
                    padding:
                        BubbleEdges.symmetric(vertical: 9.0, horizontal: 10.0),
                    radius: Radius.circular(8.0),
                    borderColor: Colors.grey[50],
                    stick: true,
                    color: Colors.white,
                    nip: BubbleNip.leftBottom,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 86.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 85.0,
                                  height: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: order['media'] != null &&
                                            order['media'].length > 0
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                AppConfig.instance.baseApiHost +
                                                    order['media'][0]['url'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          )
                                        : Image.asset(
                                            "images/image-not-found.png",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  width: 170.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      order['id'] != null
                                          ? Text(
                                              order['id'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: HexColor("#0F142B"),
                                              ),
                                            )
                                          : SizedBox.shrink(child: null),
                                      order['status'] != null
                                          ? Text(
                                              order['status'],
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: isStatusRejected
                                                    ? Colors.red
                                                    : isStatusConfirmed
                                                        ? Colors.green
                                                        : Colors.orange,
                                              ),
                                            )
                                          : SizedBox.shrink(child: null),
                                      SizedBox(height: 4),
                                      order['products'] != null &&
                                              order['products'].length > 0
                                          ? SizedBox(
                                              width: 100.0,
                                              height: 15.0,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: Text(
                                                      "Number:",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            HexColor("#53586F"),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 70.0,
                                                    child: Text(
                                                      "${order['products'].length}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(child: null),
                                      SizedBox(height: 4),
                                      SizedBox(
                                        width: 100.0,
                                        height: 15.0,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Text(
                                                "Total price:",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: HexColor("#53586F"),
                                                ),
                                              ),
                                            ),
                                            order['totalPrice'] != null
                                                ? Positioned(
                                                    top: 0,
                                                    left: 70.0,
                                                    child: Text(
                                                      "\$${order['totalPrice']}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(child: null),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderWidget(
                                  orderId: widget.orderId,
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 12.0),
                              if (widget.isAdmin &&
                                  !isStatusRejected &&
                                  !isStatusConfirmed)
                                Row(
                                  children: [
                                    Container(
                                      width: 120.0,
                                      height: 30.0,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                            BorderSide(color: Colors.red),
                                          ),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27.0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        onPressed: () => _rejectDialog(
                                            context, widget.orderId, refresh),
                                      ),
                                    ),
                                    SizedBox(width: 22.0),
                                    Container(
                                      width: 120.0,
                                      height: 30.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.disabled))
                                                return HexColor("#C4C6D2");
                                              return HexColor("#27AE60");
                                            },
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(0.0),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(27.0),
                                            ),
                                          ),
                                        ),
                                        child: isApproveClicked
                                            ? SizedBox(
                                                width: 15.0,
                                                height: 15.0,
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Text(
                                                "Approve",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                        onPressed: isApproveClicked
                                            ? null
                                            : () async {
                                                setState(() {
                                                  isApproveClicked = true;
                                                });
                                                try {
                                                  QueryResult result =
                                                      await BaseGraphQLClient
                                                          .instance
                                                          .changeOrder(
                                                              widget.orderId,
                                                              "confirmed",
                                                              "");

                                                  _sendPushNotification(
                                                      widget.orderId, true);

                                                  refresh();
                                                } catch (e) {
                                                  print(e);
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              if (isStatusRejected)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Reason why reject:",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(height: 6.0),
                                    Container(
                                      width: double.infinity,
                                      height: 51.0,
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: HexColor("#EDEEF2"),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        order['rejectedReason'] != null
                                            ? order['rejectedReason']
                                            : "",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
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
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

Future<void> _rejectDialog(
  BuildContext context,
  String orderId,
  Function notifyParent,
) async {
  String inputValue = "";

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AlertDialog(
          title: Center(child: Text('REJECT')),
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.enable('smcp')],
          ),
          titlePadding: EdgeInsets.only(top: 30.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 9.0),
                Text(
                  'Enter reason why you reject',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width * 0.85,
                  constraints: BoxConstraints(maxWidth: 355.0),
                  margin: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor("#EDEEF2"),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: TextField(
                    onChanged: (text) {
                      inputValue = text;
                    },
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Enter here',
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
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 53.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                          ),
                          child: Ink(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#FAFCFF"),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          onTap: () {
                            notifyParent();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16.0),
                          ),
                          child: Ink(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#6092DC"),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Confirm',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () async {
                            QueryResult result = await BaseGraphQLClient
                                .instance
                                .changeOrder(orderId, "cancelled", inputValue);

                            _sendPushNotification(orderId, false);
                            notifyParent();

                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
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

class _BubbleContentWidget extends StatefulWidget {
  final chatId;
  final userId;
  final formatter = new DateFormat.yMMMMd().add_jm();

  _BubbleContentWidget({this.chatId, this.userId});

  @override
  __BubbleContentWidgetState createState() => __BubbleContentWidgetState();
}

class __BubbleContentWidgetState extends State<_BubbleContentWidget> {
  Widget insetV = SizedBox(height: 36.0);
  bool _buttonShowing = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fetchDataProcess(widget.chatId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return snapshot.data['chat_messages'] == null
              ? Text('No Data', textAlign: TextAlign.center)
              : Expanded(
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollStartNotification) {
                            if (!_buttonShowing) {
                              setState(() => _buttonShowing = true);
                            }
                          } else if (scrollNotification
                              is ScrollEndNotification) {
                            if (_buttonShowing) {
                              Future.delayed(Duration(seconds: 5)).then((_) {
                                if (mounted) {
                                  setState(() {
                                    _buttonShowing = false;
                                  });
                                }
                              });
                            }
                          }
                          return false;
                        },
                        child: ListView(
                          children: snapshot.data['chat_messages']
                              .map<Widget>((chatMessage) {
                            var orderId = chatMessage['order'] != null
                                ? chatMessage['order']['id']
                                : '';

                            return chatMessage['user'] != null &&
                                    widget.userId == chatMessage['user']['id']
                                ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            chatMessage['createdAt'] != null
                                                ? Positioned(
                                                    bottom: -20.0,
                                                    left: 28.0,
                                                    child: Text(
                                                      '${widget.formatter.format(DateTime.parse(chatMessage['createdAt']))}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(child: null),
                                            Container(
                                              width: double.infinity,
                                              constraints: BoxConstraints(
                                                  minHeight: 38.0,
                                                  maxWidth: 300.0),
                                              child: Bubble(
                                                margin:
                                                    BubbleEdges.only(top: 10),
                                                elevation: 5.0,
                                                shadowColor: Colors.black26,
                                                padding: BubbleEdges.only(
                                                  top: 9.0,
                                                  bottom: 9.0,
                                                  right: 15.0,
                                                  left: 20.0,
                                                ),
                                                borderColor: Colors.grey[50],
                                                stick: true,
                                                color: Colors.white,
                                                nip: BubbleNip.rightBottom,
                                                child: Text(
                                                  chatMessage['text'] != null
                                                      ? chatMessage['text']
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                  softWrap: true,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      insetV,
                                    ],
                                  )
                                : Column(
                                    children: [
                                      chatMessage['messageType'] == 'text'
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  chatMessage['createdAt'] !=
                                                          null
                                                      ? Positioned(
                                                          bottom: -20.0,
                                                          left: 28.0,
                                                          child: Text(
                                                            '${widget.formatter.format(DateTime.parse(chatMessage['createdAt']))}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox.shrink(
                                                          child: null),
                                                  Container(
                                                    width: double.infinity,
                                                    constraints: BoxConstraints(
                                                        minHeight: 38.0,
                                                        maxWidth: 300.0),
                                                    child: Bubble(
                                                      margin: BubbleEdges.only(
                                                          top: 10),
                                                      stick: true,
                                                      elevation: 5.0,
                                                      shadowColor:
                                                          Colors.black26,
                                                      padding: BubbleEdges.only(
                                                        top: 9.0,
                                                        bottom: 9.0,
                                                        left: 15.0,
                                                        right: 20.0,
                                                      ),
                                                      borderColor:
                                                          Colors.grey[50],
                                                      color: Colors.white,
                                                      nip: BubbleNip.leftBottom,
                                                      child: Text(
                                                        chatMessage['text'] !=
                                                                null
                                                            ? chatMessage[
                                                                'text']
                                                            : '',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: HexColor(
                                                              "#53586F"),
                                                        ),
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                children: [
                                                  _ChatOrderBlock(
                                                    orderId: orderId,
                                                    createdAt: chatMessage[
                                                        'createdAt'],
                                                  ),
                                                  _ChangeOrderButton(
                                                    context: context,
                                                    orderId: orderId,
                                                  ),
                                                ],
                                              ),
                                            ),
                                      insetV,
                                    ],
                                  );
                          }).toList(),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedCrossFade(
                            duration: Duration(milliseconds: 200),
                            crossFadeState: !_buttonShowing
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: SizedBox.shrink(child: null),
                            secondChild: Container(
                              width: 136.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: HexColor("#EAECF2"),
                                borderRadius: BorderRadius.circular(17.0),
                              ),
                              child: Center(
                                  child: Text(
                                "${DateFormat("LLLL dd").format(DateTime.now())}"
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        } else {
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
                  ))
            ],
          );
        }
      },
    );
  }
}
