import 'package:com.floridainc.dosparkles/views/chat_messages_page/page.dart';
import 'package:com.floridainc.dosparkles/views/chat_page/page.dart';
import 'package:com.floridainc.dosparkles/views/forgot_password_page/page.dart';
import 'package:com.floridainc.dosparkles/views/views.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/state.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';

class Routes {
  static final PageRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'emptyscreenpage': EmptyScreenPage(),
      'startpage': StartPage(),
      'loginpage': LoginPage(),
      'storeselectionpage': StoreSelectionPage(),
      'storepage': StorePage(),
      'productpage': ProductPage(),
      'cartpage': CartPage(),
      'registrationpage': RegistrationPage(),
      'invite_friendpage': InviteFriendPage(),
      'settingspage': SettingsPage(),
      'notificationspage': NotificationsPage(),
      'dashboardpage': DashboardPage(),
      'profilepage': ProfilePage(),
      'forgot_passwordpage': ForgotPasswordPage(),
      'reset_passwordpage': ResetPasswordPage(),
      'customize_linkpage': CustomizeLinkPage(),
      'settings_page': SettingsPage(),
      'chatpage': ChatPage(),
      'chatmessagespage': ChatMessagesPage(),
      'registerpage': RegisterPage(),
      'addphonepage': AddPhonePage(),
      'helpsupportpage': HelpSupportPage(),
      'uploadvideopage': UploadVideo(),
    },
    visitor: (String path, Page<Object, dynamic> page) {
      if (page.isTypeof<GlobalBaseState>()) {
        page.connectExtraStore<GlobalState>(GlobalStore.store,
            (Object pagestate, GlobalState appState) {
          final GlobalBaseState p = pagestate;
          if (p.locale != appState.locale ||
              p.user != appState.user ||
              p.connectionStatus != appState.connectionStatus ||
              p.storesList != appState.storesList ||
              p.selectedStore != appState.selectedStore ||
              p.selectedProduct != appState.selectedProduct ||
              p.shoppingCart != appState.shoppingCart ||
              p.connectionStatus != appState.connectionStatus) {
            if (pagestate is Cloneable) {
              final Object copy = pagestate.clone();
              final GlobalBaseState newState = copy;
              newState.locale = appState.locale;
              newState.user = appState.user;
              newState.storesList = appState.storesList;
              newState.selectedStore = appState.selectedStore;
              newState.selectedProduct = appState.selectedProduct;
              newState.shoppingCart = appState.shoppingCart;
              newState.connectionStatus = appState.connectionStatus;
              return newState;
            }
          }
          return pagestate;
        });
      }
      page.enhancer.append(
        /// View AOP
        viewMiddleware: <ViewMiddleware<dynamic>>[
          safetyView<dynamic>(),
        ],

        /// Adapter AOP
        adapterMiddleware: <AdapterMiddleware<dynamic>>[
          safetyAdapter<dynamic>()
        ],

        /// Effect AOP
        effectMiddleware: [
          _pageAnalyticsMiddleware<dynamic>(),
        ],

        /// Store AOP
        middleware: <Middleware<dynamic>>[
          logMiddleware<dynamic>(tag: page.runtimeType.toString()),
        ],
      );
    },
  );
}

EffectMiddleware<T> _pageAnalyticsMiddleware<T>() {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          print('${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}
