import 'dart:convert' show json;
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';

class ProductItem {
  String id;

  String name;

  String shineonImportId;

  String thumbnailUrl;

  List<dynamic> videoUrls;

  double oldPrice;

  double price;

  bool showOldPrice;

  bool engraveAvailable;

  dynamic properties;

  dynamic shineonIds;

  double engraveOldPrice;

  double engravePrice;

  bool showOldEngravePrice;

  String defaultFinishMaterial;

  String optionalFinishMaterial;

  double optionalFinishMaterialPrice;

  bool optionalFinishMaterialEnabled;

  List<dynamic> mediaUrls;

  bool uploadsAvailable;

  bool sizeOptionsAvailable;

  bool isActive;

  String engraveExampleUrl;

  String optionalMaterialExampleUrl;

  List orders;

  String productDetails;

  String deliveryTime;

  double optionalFinishMaterialOldPrice;

  bool showOptionalFinishMaterialOldPrice;

  bool isNew;

  int orderInList;

  ProductItem.fromParams({
    this.id,
    this.name,
    this.shineonImportId,
    this.thumbnailUrl,
    this.videoUrls,
    this.oldPrice,
    this.price,
    this.showOldPrice,
    this.engraveAvailable,
    this.properties,
    this.engraveOldPrice,
    this.engravePrice,
    this.showOldEngravePrice,
    this.defaultFinishMaterial,
    this.optionalFinishMaterial,
    this.optionalFinishMaterialPrice,
    this.optionalFinishMaterialEnabled,
    this.mediaUrls,
    this.uploadsAvailable,
    this.sizeOptionsAvailable,
    this.isActive,
    this.engraveExampleUrl,
    this.optionalMaterialExampleUrl,
    this.orders,
    this.productDetails,
    this.deliveryTime,
    this.optionalFinishMaterialOldPrice,
    this.showOptionalFinishMaterialOldPrice,
    this.isNew,
    this.orderInList,
  });

  factory ProductItem(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ProductItem.fromJson(json.decode(jsonStr))
          : new ProductItem.fromJson(jsonStr);

  ProductItem.fromJson(jsonRes) {
    id = jsonRes['id'] != null ? jsonRes['id'] : jsonRes['_id'];
    name = jsonRes['name'];
    shineonImportId = jsonRes['shineonImportId'];
    thumbnailUrl = jsonRes['thumbnail'] != null
        ? AppConfig.instance.baseApiHost + jsonRes['thumbnail']['url']
        : null;

    engraveExampleUrl = jsonRes['engraveExample'] != null
        ? AppConfig.instance.baseApiHost + jsonRes['engraveExample']['url']
        : null;

    optionalMaterialExampleUrl = jsonRes['optionalMaterialExample'] != null
        ? AppConfig.instance.baseApiHost +
            jsonRes['optionalMaterialExample']['url']
        : null;

    oldPrice = checkDouble(jsonRes['oldPrice']);
    price = checkDouble(jsonRes['price']);
    showOldPrice = jsonRes['showOldPrice'];
    engraveAvailable = jsonRes['engraveAvailable'];

    properties = jsonRes['properties'];
    shineonIds = jsonRes['shineonIds'];
    isNew = jsonRes['new'];
    orderInList = jsonRes['orderInList'];

    engraveOldPrice = checkDouble(jsonRes['engraveOldPrice']);
    engravePrice = checkDouble(jsonRes['engravePrice']);
    showOldEngravePrice = jsonRes['showOldEngravePrice'];

    defaultFinishMaterial = jsonRes['defaultFinishMaterial'];
    optionalFinishMaterial = jsonRes['optionalFinishMaterial'];

    optionalFinishMaterialPrice =
        checkDouble(jsonRes['optionalFinishMaterialPrice']);
    optionalFinishMaterialEnabled = jsonRes['optionalFinishMaterialEnabled'];

    if (jsonRes['media'] != null) {
      mediaUrls = jsonRes['media']
          .map(
              (item) => AppConfig.instance.baseApiHost + item['url'].toString())
          .toList();
    } else {
      mediaUrls = List.empty();
    }

    if (jsonRes['video'] != null) {
      videoUrls = jsonRes['video']
          .map(
              (item) => AppConfig.instance.baseApiHost + item['url'].toString())
          .toList();
    } else {
      videoUrls = List.empty();
    }

    uploadsAvailable = jsonRes['uploadsAvailable'];
    sizeOptionsAvailable = jsonRes['sizeOptionsAvailable'];
    isActive = jsonRes['isActive'];
    orders = jsonRes['orders'];
    productDetails = jsonRes['productDetails'];
    deliveryTime = jsonRes['deliveryTime'];
    optionalFinishMaterialOldPrice =
        checkDouble(jsonRes['optionalFinishMaterialOldPrice']);

    showOptionalFinishMaterialOldPrice =
        jsonRes['showOptionalFinishMaterialOldPrice'];
  }
  @override
  String toString() {
    return '{"name": "$name","id": "$id","price": "$price"}';
  }
}
