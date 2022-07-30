import 'package:fish_redux/fish_redux.dart';

enum LoginPageAction {
  action,
  loginclicked,
  signUp,
  googleSignIn,
  facebookSignIn,
  setIsLoading
}

class LoginPageActionCreator {
  static Action onAction() {
    return const Action(LoginPageAction.action);
  }

  static Action onLoginClicked() {
    return const Action(LoginPageAction.loginclicked);
  }

  static Action onSignUp() {
    return const Action(LoginPageAction.signUp);
  }

  static Action onGoogleSignIn() {
    return const Action(LoginPageAction.googleSignIn);
  }

  static Action onFacebookSignIn() {
    return const Action(LoginPageAction.facebookSignIn);
  }

  static Action onSetIsLoading(bool payload) {
    return Action(LoginPageAction.setIsLoading, payload: payload);
  }
}
