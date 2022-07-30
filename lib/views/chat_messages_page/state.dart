import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/models/app_user.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class ChatMessagesPageState
    implements GlobalBaseState, Cloneable<ChatMessagesPageState> {
  PageController pageController;
  bool isFirstTime;
  String chatId;
  String userId;
  String conversationName;

  @override
  ChatMessagesPageState clone() {
    return ChatMessagesPageState()
      ..pageController = pageController
      ..isFirstTime = isFirstTime
      ..chatId = chatId
      ..userId = userId
      ..conversationName = conversationName;
  }

  @override
  Locale locale;

  @override
  AppUser user;

  @override
  List<StoreItem> storesList;

  @override
  StoreItem selectedStore;

  @override
  ProductItem selectedProduct;

  @override
  List<CartItem> shoppingCart;

  @override
  String connectionStatus;
}

ChatMessagesPageState initState(Map<String, dynamic> args) {
  ChatMessagesPageState state = ChatMessagesPageState();
  state.chatId = args['chatId'];
  state.userId = args['userId'];
  state.conversationName = args['conversationName'];

  return state;
}
