import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_service.dart';

class BaseGraphQLClient {
  BaseGraphQLClient._();

  static final BaseGraphQLClient _instance = BaseGraphQLClient._();
  static BaseGraphQLClient get instance => _instance;
  final GraphQLService _service = GraphQLService()
    ..setupClient(
      httpLink: AppConfig.instance.graphQLHttpLink,
      // webSocketLink: AppConfig.instance.graphQlWebSocketLink
    );

  void setToken(String token) {
    _service.setupClient(
        httpLink: AppConfig.instance.graphQLHttpLink,
        /*webSocketLink: null, */ token: token);
  }

  void removeToken() {
    _service.setupClient(
      httpLink: AppConfig.instance.graphQLHttpLink, /*webSocketLink: null*/
    );
  }

  Future<QueryResult> loginWithEmail(String email, String password) {
    removeToken();

    String _mutation = '''
      mutation {
        login (input: {
            identifier: "$email",
            password: "$password"
        })
        {
          user {
            id
            username
            email
            role {
              name
              type
              description
            }
          }
          jwt
        }
      }
    ''';
    return _service.mutate(_mutation);
  }

  Future<QueryResult> me() {
    String _query = '''
      query {
        me {
          id
          user {
            id
            email
            username
            shippingAddress
            enableNotifications
            invitesSent
            phoneNumber
            referralLink
            provider
            storeFavorite {
              id
              name
            }
            store {
              id
              name
            }
            role {
              id
              name
            }
            name
            country
            orders {
              id
              status
              orderDetails
              totalPrice
              createdAt
              products {
              id
              shineonImportId
              new
              orderInList
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              productDetails
              deliveryTime
              price
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
              }
            }
            avatar {
              url
            }
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchUsers() {
    String _query = '''
      query {
        users {
          id
          email
          username
          enableNotifications
          phoneNumber
          shippingAddress
          invitesSent
          referralLink
          storeFavorite {
            id
            name
          }
          store {
            id
            name
          }
          role {
            id
            name
          }
          name
          country
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchUserById(String id) {
    String _query = '''
      query {
        users ( where: { id: "$id" } ) {
          id
          email
          username
          enableNotifications
          phoneNumber
          shippingAddress
          referralLink
          invitesSent
          storeFavorite {
            id
            name
          }
          store {
            id
            name
          }
          role {
            id
            name
          }
          name
          country
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchUserByEmail(String email) {
    String _query = '''
      query {
        users ( where: { email: "$email" } ) {
          id
          email
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> checkUserFields(String id) {
    String _query = '''
      query {
        users(where: { id: "$id" }) {
          id
          phoneNumber
          storeFavorite {
            id
            name
          }
        }
      }
    ''';
    return _service.query(_query);
  }

  Future<QueryResult> fetchUserByReferralLink(String referralLink) {
    String _query = '''
      query {
        users ( where: { referralLink: "$referralLink" } ) {
          id
          referralLink
          storeFavorite {
            id
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchUserNotification(String id) {
    String _query = '''
      query {
        users ( where: { id: "$id" } ) {
          enableNotifications
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> setUserPhoneNumber(String id, String phoneNumber) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              phoneNumber: "$phoneNumber"
            }
          }
        )
        {
          user {
            id
            email
            username
            enableNotifications
            phoneNumber
            invitesSent
            referralLink
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> setUserReferralLink(String id, String link) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              referralLink: "$link"
            }
          }
        )
        {
          user {
            id
            email
            username
            enableNotifications
            phoneNumber
            invitesSent
            referralLink
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> setUserAvatar(String id, String imageId) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              avatar: $imageId
            }
          }
        )
        {
          user {
            id
            email
            username
            enableNotifications
            phoneNumber
            avatar {
              id
              url
            }
            invitesSent
              referralLink
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> setUserNotifications(String id, bool value) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              enableNotifications: $value
            }
          }
        )
        {
          user {
            id
            email
            username
            enableNotifications
            phoneNumber
            avatar {
              id
              url
            }
            invitesSent
            referralLink
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> setUserFavoriteStore(String id, String storeId) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              storeFavorite: "$storeId"
            }
          }
        )
        {
          user {
            id
            email
            username
            enableNotifications
            phoneNumber
            avatar {
              id
              url
            }
            invitesSent
            referralLink
            role {
              id
              name
            }
            storeFavorite {
              id
              name
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> registerUser(Map data) {
    String _mutation = '''
      mutation {
        register (
          input: { 
            data: {
              email: "${data['emailValue']}"
              username: "${data['emailValue']}"
              password: "${data['passwordValue']}"
            }
          }
        ) 
        {
          jwt
          user {
            id
            username
            email
            role {
              id
              name
            }
          }
        }
      }
    ''';

    return _service.query(_mutation);
  }

  Future<QueryResult> updateUserOnCreate(String id, Map data) {
    String _mutation = '''
      mutation UpdateUser {
        updateUser (
          input: {
            where: {
              id: "$id"
            },
            data: {
              name: "${data['fullName']}"
            }
          }
        ) 
        {
          user {
            id
            email
            enableNotifications
            username
            shippingAddress
            storeFavorite {
              id
              name
            }
            store {
              id
              name
            }
            role {
              id
              name
            }
            name
            country
          }
        }
      }
    ''';

    return _service.query(_mutation);
  }

  Future<QueryResult> storesWithProductsList() {
    String _query = '''
      query {
        stores {
          id
          name
          address
          phone
          lat
          lng
          thumbnail {
            url
          }
          chats {
            id
            store {
              id 
              name
            }
          }
          products {
            id
            new
            shineonImportId
            optionalFinishMaterialOldPrice
            showOptionalFinishMaterialOldPrice
            orderInList
            thumbnail {
              url
            }
            video {
              url
            }
            engraveExample {
              url
              name
            }
            optionalMaterialExample {
              url
            }
            orders {
              id
            }
            oldPrice
            price
            productDetails
            deliveryTime
            showOldPrice
            engraveAvailable
            properties
            shineonIds
            engraveOldPrice
            engravePrice
            showOldEngravePrice
            defaultFinishMaterial
            optionalFinishMaterial
            optionalFinishMaterialPrice
            optionalFinishMaterialEnabled
            media {
              url
            }
            name
            uploadsAvailable
            sizeOptionsAvailable
            isActive
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchStoreById(String id) {
    String _query = '''
      query {
        stores ( where: { id: "$id" } ) {
          id
          name
          address
          phone
          lat
          lng
          thumbnail {
            url
          }
          chats {
            id
            users {
              id
              email
              name
            }
            store {
              id
              name
            }
            chat_messages {
              id
              text
              createdAt
              messageType
              order {
                id
              }
              chat {
                id
              }
              user {
                id
                name
              }
            }
          }
          products {
            id
            new
            shineonImportId
                          optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
            thumbnail {
              url
            }
            video {
              url
            }
            engraveExample {
              url
              name
            }
            optionalMaterialExample {
              url
            }
            orders {
              id
            }
            oldPrice
            price
            productDetails
              deliveryTime
            showOldPrice
            engraveAvailable
            properties
            shineonIds
            engraveOldPrice
            engravePrice
            showOldEngravePrice
            defaultFinishMaterial
            optionalFinishMaterial
            optionalFinishMaterialPrice
            optionalFinishMaterialEnabled
            media {
              url
            }
            name
            uploadsAvailable
            sizeOptionsAvailable
            isActive
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> updateStoreOrder(String id, List<String> orderIds) {
    String _mutation = '''
      mutation UpdateStore {
        updateStore (
          input: {
            where: {
              id: "$id"
            }
            data:{
              orders: $orderIds      
            }
          }
        ) 
        {
          store {
            id
            name
            address
            phone
            orders {
              id
            }
            lat
            lng
            thumbnail {
              url
            }
            chats {
              id
              users {
                id
                email
                name
              }
              store {
                id
                name
              }
              chat_messages {
                id
                text
                createdAt
                messageType
                order {
                  id
                }
                chat {
                  id
                }
                user {
                  id
                  name
                }
              }
            }
            products {
              id
              new
              shineonImportId
                            optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              price
              productDetails
              deliveryTime
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> setStoreThumbnail(String id, String imageId) {
    String _mutation = '''
      mutation UpdateStore {
        updateStore (
          input: {
            where: {
              id: "$id"
            }
            data: {
              thumbnail: $imageId
            }
          }
        )
        {
          store {
            id
            name
            address
            phone
            orders {
              id
            }
            lat
            lng
            thumbnail {
              id
              url
            }
            chats {
              id
              users {
                id
                email
                name
              }
              store {
                id
                name
              }
              chat_messages {
                id
                text
                createdAt
                messageType
                order {
                  id
                }
                chat {
                  id
                }
                user {
                  id
                  name
                }
              }
            }
            products {
              id
              new
              shineonImportId
                            optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              price
              productDetails
              deliveryTime
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> createOrder(
    String orderDetailsJson,
    double totalPrice,
    String productsIdsJson,
    String cardToken,
  ) {
    String _mutation = '''
      mutation CreateOrder {
        createOrder (
          input: {
            data:{
              orderDetails: $orderDetailsJson,
              totalPrice: $totalPrice,
              products: $productsIdsJson,
              cardToken: "$cardToken",
            }
          }
        ) 
        {
          order {
            id
            orderDetails
            status
            refunded
            cardToken
            totalPrice
            products {
              id
              new
              shineonImportId
               optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              price
              productDetails
              deliveryTime
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                url
              }

              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
            media {
              id
            }
            shipmentDetails
            shineonId
          }
        }
      }
    ''';

    return _service.query(_mutation);
  }

  Future<QueryResult> fetchOrder(String orderId) {
    String _query = '''
      query {
        orders (where: { id: "$orderId" }) {
          id
          orderDetails
          status
          refunded
          totalPrice
          products {
            id
            new
            shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
            thumbnail {
              url
            }
            video {
              url
            }
            engraveExample {
              url
            }
            optionalMaterialExample {
              url
            }
            orders {
              id
            }
            oldPrice
            price
            showOldPrice
            productDetails
              deliveryTime
            engraveAvailable
            properties
            shineonIds
            engraveOldPrice
            engravePrice
            showOldEngravePrice
            defaultFinishMaterial
            optionalFinishMaterial
            optionalFinishMaterialPrice
            optionalFinishMaterialEnabled
            media {
              url
            }
            name
            uploadsAvailable
            sizeOptionsAvailable
            isActive
          }
          media {
            id
            url
          }
          shipmentDetails
          shineonId
          rejectedReason
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> changeOrder(
      String id, String status, String rejectedReason) {
    String _mutation = '''
      mutation UpdateOrder {
        updateOrder (
          input: {
            where: {
              id: "$id"
            }
            data:{
              status: $status              
              rejectedReason: "$rejectedReason"
            }
          }
        ) 
        {
          order {
            id
            orderDetails
            status
            refunded
            totalPrice
            rejectedReason
            media {
              id
            }
            shipmentDetails
            shineonId
          }
        }
      }
    ''';

    return _service.query(_mutation);
  }

  Future<QueryResult> signUp(String identifier, String password) {
    String _mutation = '''
      mutation {
        register (
          input: {
            username: "$identifier",
            email: "$identifier",
            password: "$password"
          }
        )
        {
          user {
            id
            username
            email
            role {
              name
              type
              description
            }
          }
          jwt
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> forgotPassword(String email) {
    String _mutation = '''
      mutation {
        forgotPassword (
          email: "$email"
        ) {
          ok
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> resetPassword(
    String code,
    String passwordValue,
    String repeatPassValue,
  ) {
    String _mutation = '''
      mutation {
        resetPassword (
          code: "$code",
          password: "$passwordValue",
          passwordConfirmation: "$repeatPassValue"
        ) {
          user {
            id
          }
        }
      }
    ''';
    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateUser(id, String data) {
    String _mutation = '''
      mutation UserUpdate(\$input: updateUserInput!) {
        updateUser(input: \$input) {
          user {
            id
            email
            enableNotifications
            name
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation, variables: {
      "input": {
        "where": {"id": "$id"},
        "data": {"pushToken": "$data"}
      }
    });
  }

  Future<QueryResult> setUsersFavoriteStore(String id, String storeFavorite) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              storeFavorite: "$storeFavorite"
            }
          }
        )
        {
          user {
            id
            email
            username
            phoneNumber
            enableNotifications
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> fetchChats() {
    String _query = '''
      query {
        chats {
          id
          users {
            id
            email
            enableNotifications
            name
            avatar {
              url
            }
          }
          store {
            id
            name
            createdAt
            thumbnail {
              id
              url
            }
          }
          chat_messages {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
            }
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchChat(String chatId) {
    String _query = '''
      query {
        chats(where: { id: "$chatId" }) {
          id
          users {
            id
            email
            name
            enableNotifications
            avatar {
              url
            }
          }
          store {
            id
            name
            createdAt
            thumbnail {
              id
              url
            }
          }
          chat_messages {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
              avatar {
                url
              }
            }
          }
        }
      }
      
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> createOrderChat(List<String> ids, String storeId) {
    String _mutation = '''
      mutation {
        createChat (
          input: {
            data: {
              users: $ids
              store: "$storeId"
            }
          }
        ) 
        {
          chat {
            id
            store {
              id
              name
            }
            users {
              id
              email
              enableNotifications
              name
              avatar {
              url
            }
            }
            chat_messages {
              id
              text
              createdAt
              order {
                id
              }
              messageType
              user {
                id
                name
              }
            }
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> createOrderMessage(
    String chatId,
    String orderId,
  ) {
    String _mutation = '''
      mutation {
        createChatmessage (
          input: {
            data: {
              chat: "$chatId"
              order: "$orderId"
              messageType: order
            }
          }
        )
        {
          chatmessage {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
              avatar {
                url
              }
            }
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> createMessage(Map<String, dynamic> data) {
    String _mutation = '''
      mutation {
        createChatmessage (
          input: {
            data: {
              text: "${data['text']}"
              chat: "${data['chat']}"
              user: "${data['user']}"
            }
          }
        )
        {
          chatmessage {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
            }
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> fetchAppContent() {
    String _query = '''
      query {
        appContent {
          id
          privacyPolicy
          termsAndConditions
          termsAndConditionsInvite
          aboutUs
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> createSupportRequest(
      name, email, subjectChoice, message) {
    String _mutation = '''
      mutation {
        createSupportRequest (
          input: {
            data: {
              name: "$name"
              email: "$email"
              subjectChoice: $subjectChoice
              message: "$message"
            }
          }
        )
        {
          supportRequest {
            name
            email
            subjectChoice
            message
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateProductMedia(String id, List<String> productIds) {
    String _mutation = '''
      mutation UpdateProduct {
        updateProduct (
          input: {
            where: {
              id: "$id"
            }
            data:{
              media: $productIds      
            }
          }
        ) 
        {
					product {
              id
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              price
              productDetails
              deliveryTime
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                id
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateOrderEngravingName(String id, List data) {
    String _mutation = '''
      mutation UpdateOrder(\$input: updateOrderInput) {
         updateOrder (input: \$input)
         {
          order {
           id
           orderDetails
           status
           refunded
           totalPrice
           products {
             id
             new
             shineonImportId
             optionalFinishMaterialOldPrice
             showOptionalFinishMaterialOldPrice
             thumbnail {
               url
             }
             video {
               url
             }
             engraveExample {
               url
             }
             optionalMaterialExample {
               url
             }
             orders {
               id
             }
             oldPrice
             price
             showOldPrice
             productDetails
               deliveryTime
             engraveAvailable
             properties
             shineonIds
             engraveOldPrice
             engravePrice
             showOldEngravePrice
             defaultFinishMaterial
             optionalFinishMaterial
             optionalFinishMaterialPrice
             optionalFinishMaterialEnabled
             media {
               url
             }
             name
             uploadsAvailable
             sizeOptionsAvailable
             isActive
           }
           media {
             id
             url
           }
           shipmentDetails
           shineonId
           rejectedReason
         }
       }
}
    ''';

    return _service.mutate(
      _mutation,
      variables: {
        "input": {
          "where": {"id": "$id"},
          "data": {"orderDetails": data}
        }
      },
    );
  }

  Future<QueryResult> fetchProductById(String id) {
    String _query = '''
      query {
        products (where: { id: "$id" }) {
              id
              new
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
              orderInList
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
              }
              optionalMaterialExample {
                url
              }
              orders {
                id
              }
              oldPrice
              price
              productDetails
              deliveryTime
              showOldPrice
              engraveAvailable
              properties
              shineonIds
              engraveOldPrice
              engravePrice
              showOldEngravePrice
              defaultFinishMaterial
              optionalFinishMaterial
              optionalFinishMaterialPrice
              optionalFinishMaterialEnabled
              media {
                id
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
        }
      
    ''';

    return _service.query(_query);
  }
}
