import 'package:com.floridainc.dosparkles/models/cart_item_model.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'action.dart';
import 'state.dart';

Effect<CartPageState> buildEffect() {
  return combineEffects(<Object, Effect<CartPageState>>{
    CartPageAction.action: _onAction,
    CartPageAction.setProductCount: _onSetProductCount,
    CartPageAction.removeCartItem: _onRemoveCartItem,
    CartPageAction.proceedToCheckout: _onProceedToCheckout,
    CartPageAction.backToProduct: _onBackToProduct,
    Lifecycle.initState: _onInit,
    Lifecycle.build: _onBuild,
    Lifecycle.dispose: _onDispose,
  });
}

void _onInit(Action action, Context<CartPageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animationController = AnimationController(
      vsync: ticker, duration: Duration(milliseconds: 2000));

  ctx.state.user = GlobalStore.store.getState().user;
  ctx.state.locale = GlobalStore.store.getState().locale;
  ctx.state.storesList = GlobalStore.store.getState().storesList;
  ctx.state.selectedProduct = GlobalStore.store.getState().selectedProduct;
  ctx.state.selectedStore = GlobalStore.store.getState().selectedStore;
  ctx.state.shoppingCart = GlobalStore.store.getState().shoppingCart;
  ctx.state.connectionStatus = GlobalStore.store.getState().connectionStatus;
}

void _onBuild(Action action, Context<CartPageState> ctx) {
  Future.delayed(Duration(milliseconds: 150),
      () => ctx.state.animationController.forward());
}

void _onDispose(Action action, Context<CartPageState> ctx) {
  ctx.state.animationController.dispose();
}

void _onAction(Action action, Context<CartPageState> ctx) {}

void _onSetProductCount(Action action, Context<CartPageState> ctx) {
  CartItem cartItem = action.payload[0];
  int count = action.payload[1];

  for (var i = 0; i < ctx.state.shoppingCart.length; i++) {
    if (ctx.state.shoppingCart[i] == cartItem) {
      double basePrice =
          ctx.state.shoppingCart[i].amount / ctx.state.shoppingCart[i].count;
      ctx.state.shoppingCart[i].count = count;
      ctx.state.shoppingCart[i].amount = basePrice * count;

      break;
    }
  }

  ctx.dispatch(
      CartPageActionCreator.onSetProductCountUpdate(ctx.state.shoppingCart));

  GlobalStore.store
      .dispatch(GlobalActionCreator.setShoppingCart(ctx.state.shoppingCart));
}

void _onRemoveCartItem(Action action, Context<CartPageState> ctx) {
  CartItem cartItem = action.payload;

  ctx.state.shoppingCart.removeWhere((element) => element == cartItem);

  GlobalStore.store
      .dispatch(GlobalActionCreator.setShoppingCart(ctx.state.shoppingCart));

  ctx.dispatch(
      CartPageActionCreator.onSetProductCountUpdate(ctx.state.shoppingCart));

  if (ctx.state.shoppingCart.length == 0) {
    Navigator.of(ctx.context)
        .pushReplacementNamed('storepage', arguments: {'listView': true});
  }
}

String processCartItemForOrder(CartItem item) {
  String sku;
  String properties;
  String url = "https://backend.dosparkles.com";

  // TODO: "print_url": "http://lorempixel.com/100/100/",

  bool hasEngraving = false;

  if (item.product.engraveAvailable) {
    var empty = true;
    if (item.engraveInputs != null)
      for (var i = 0; i < item.engraveInputs.length; i++) {
        if (item.engraveInputs[i].trim().length > 0) {
          empty = false;
          break;
        }
      }
    if (!empty) {
      hasEngraving = true;
    }
  }

  if (!hasEngraving && !item.optionalMaterialSelected) {
    sku = item.product.shineonIds['simple'];
  } else if (!hasEngraving && item.optionalMaterialSelected) {
    sku = item.product.shineonIds['withMaterial'];
  } else if (hasEngraving && !item.optionalMaterialSelected) {
    sku = item.product.shineonIds['withEngraving'];
  } else if (hasEngraving && item.optionalMaterialSelected) {
    sku = item.product.shineonIds['withEngravingAndMaterial'];
  }

  properties = '{ Engraving_Font: "Tangerine"';

  if (hasEngraving) {
    for (var i = 0; i < item.engraveInputs.length; i++) {
      properties += ', Engraving_Line_${i + 1}: "${item.engraveInputs[i]}"';
    }
  }

  properties += ' }';

  var result =
      '{ store_line_item_id: "${item.product.id}", sku: "$sku", quantity: ${item.count}, properties: $properties }';

  return result;
}

void _onProceedToCheckout(Action action, Context<CartPageState> ctx) async {
  var isMe = GlobalStore.store.getState().user.role == 'Store Manager';

  List<CartItem> cart = ctx.state.shoppingCart;

  if (cart == null || cart.length == 0 || isMe) return;

  String orderDetailsJson;
  double totalPrice = 0;
  String productsIdsJson;

  orderDetailsJson =
      "[${cart.map((item) => processCartItemForOrder(item)).join(',')}]";

  for (var i = 0; i < cart.length; i++) {
    totalPrice += cart[i].amount;
  }

  productsIdsJson = "[${cart.map((item) => '"${item.product.id}"').join(',')}]";

  GlobalStore.store.dispatch(GlobalActionCreator.setShoppingCart(
      List<CartItem>.empty(growable: true)));

  QueryResult resultOrder = await BaseGraphQLClient.instance.createOrder(
    orderDetailsJson,
    totalPrice,
    productsIdsJson,
    ctx.state.paymentToken,
  );

  QueryResult storeResult = await BaseGraphQLClient.instance
      .fetchStoreById(ctx.state.selectedStore.id);

  var foundStore = storeResult.data['stores'][0];

  List storeChats = foundStore['chats'];

  String myId = GlobalStore.store.getState().user.id;
  bool isExistUser;

  for (int i = 0; i < storeChats.length; i++) {
    var chatUsers = storeChats[i]['users'];
    for (int j = 0; j < chatUsers.length; j++) {
      var chatId = chatUsers[j]['id'];

      if (chatId == myId) {
        isExistUser = true;
      } else {
        isExistUser = false;
      }
    }
  }

  if (foundStore['orders'] != null && foundStore['orders'].length > 0) {
    List<String> orderIds = [];

    for (int i = 0; i < foundStore['orders']; i++) {
      var order = foundStore['orders'][i];
      orderIds.add("\"${order['id']}\"");
    }

    orderIds.add("\"${resultOrder.data['createOrder']['order']['id']}\"");
    QueryResult storeOrderResult = await BaseGraphQLClient.instance
        .updateStoreOrder(foundStore['id'], orderIds);
  } else {
    QueryResult storeOrderResult =
        await BaseGraphQLClient.instance.updateStoreOrder(
      foundStore['id'],
      ["\"${resultOrder.data['createOrder']['order']['id']}\""],
    );
  }

  if (isExistUser == false || storeChats == null || storeChats.length == 0) {
    QueryResult resultChat = await BaseGraphQLClient.instance
        .createOrderChat(["\"$myId\""], ctx.state.selectedStore.id);

    await BaseGraphQLClient.instance.createOrderMessage(
      resultChat.data['createChat']['chat']['id'],
      resultOrder.data['createOrder']['order']['id'],
    );

    Navigator.of(ctx.context).pushReplacementNamed(
      'chatmessagespage',
      arguments: {
        'chatId': resultChat.data['createChat']['chat']['id'],
        'userId': myId,
        'conversationName': resultChat.data['createChat']['chat']['store']
            ['name']
      },
    );
  }

  if (isExistUser == true) {
    QueryResult resultMessage =
        await BaseGraphQLClient.instance.createOrderMessage(
      storeChats[0]['id'],
      resultOrder.data['createOrder']['order']['id'],
    );

    Navigator.of(ctx.context).pushReplacementNamed(
      'chatmessagespage',
      arguments: {
        'chatId': storeChats[0]['id'],
        'userId': myId,
        'conversationName': storeChats[0]['store']['name'],
      },
    );
  }
}

void _onBackToProduct(Action action, Context<CartPageState> ctx) async {
  Navigator.of(ctx.context)
      .pushReplacementNamed('storepage', arguments: {'listView': false});
}
