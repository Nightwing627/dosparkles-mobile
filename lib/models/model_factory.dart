import 'models.dart';
class ModelFactory {
  static T generate<T>(json) {
    switch (T.toString()) {
      case 'AppUser':
        return AppUser(json) as T;
      case 'StoreItem':
        return StoreItem(json) as T;
       case 'ProductItem':
        return ProductItem(json) as T;
      default:
        return json;
    }
  }
}
