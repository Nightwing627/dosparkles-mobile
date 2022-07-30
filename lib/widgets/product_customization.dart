import 'package:cached_network_image/cached_network_image.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/product_page/action.dart';
import 'package:com.floridainc.dosparkles/views/store_page/action.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCustomization extends StatefulWidget {
  final Dispatch dispatch;
  final ProductItem selectedProduct;
  final int productQuantity;
  final bool optionalMaterialSelected;
  final List<String> engraveInputs;

  ProductCustomization({
    this.dispatch,
    this.selectedProduct,
    this.productQuantity,
    this.engraveInputs,
    this.optionalMaterialSelected,
  });

  @override
  ProductCustomizationState createState() => new ProductCustomizationState(
        dispatch: dispatch,
        selectedProduct: selectedProduct,
        productQuantity: productQuantity,
        engraveInputs: engraveInputs,
        optionalMaterialSelected: optionalMaterialSelected,
      );
}

class ProductCustomizationState extends State<ProductCustomization> {
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

  Dispatch dispatch;
  ProductItem selectedProduct;
  int productQuantity;
  bool optionalMaterialSelected;
  List<String> engraveInputs;

  List<TextEditingController> engravingControllers = List.empty(growable: true);

  ProductCustomizationState({
    this.dispatch,
    this.selectedProduct,
    this.productQuantity,
    this.engraveInputs,
    this.optionalMaterialSelected,
  });

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    int engravingsCount = 0;

    if (selectedProduct != null &&
        selectedProduct.properties != null &&
        selectedProduct.properties['engravings'] != null) {
      var engravings = selectedProduct.properties['engravings'];

      if (engravings is int) {
        engravingsCount = engravings;
      } else {
        engravingsCount = int.tryParse(engravings) ?? 0;
      }
    }

    if (engravingsCount > 0) {
      if (engravingControllers == null || engravingControllers.length == 0) {
        engravingControllers = List.empty(growable: true);
      }

      for (var i = 0; i < engravingsCount; i++) {
        var controller = TextEditingController();
        if (engraveInputs != null && engraveInputs.length > i) {
          controller..text = engraveInputs[i];
        }
        engravingControllers.add(controller);
      }
    }

    double wholeSum = productQuantity * selectedProduct.price;
    double wholeOldSum = productQuantity * selectedProduct.oldPrice;

    if (optionalMaterialSelected) {
      wholeSum += selectedProduct.optionalFinishMaterialPrice;
      wholeOldSum += selectedProduct.optionalFinishMaterialOldPrice;
    }

    bool isNotEmpty = engravingControllers
        .where((TextEditingController el) => el.text != null && el.text != '')
        .toList()
        .isNotEmpty;

    if (isNotEmpty) {
      wholeSum += selectedProduct.engravePrice;
      wholeOldSum += selectedProduct.engraveOldPrice;
    }

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
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Image.asset("images/close_button_terms.png"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: 83.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 300.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(HexColor("#6092DC")),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(31.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Customize and Proceed',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        await dispatch(
                          StorePageActionCreator.onAddToCart(
                            selectedProduct,
                            productQuantity,
                          ),
                        );
                        dispatch(StorePageActionCreator.onGoToCart());
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: CustomRefreshIndicator(
              offsetToArmed: 0,
              onRefresh: () {
                Navigator.of(context).pushNamed(
                  'storepage',
                  arguments: {'listView': false},
                );
                Future<void> delayed =
                    Future.delayed(const Duration(milliseconds: 1));
                return delayed;
              },
              builder: (
                BuildContext context,
                Widget child,
                IndicatorController controller,
              ) {
                return AnimatedBuilder(
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0.0, 0.0),
                      child: child,
                    );
                  },
                  animation: controller,
                );
              },
              child: GestureDetector(
                onVerticalDragEnd: (dragEndDetails) {
                  if (dragEndDetails.primaryVelocity > 0) {
                    // Page down

                    Navigator.of(context).pushNamed(
                      'storepage',
                      arguments: {'listView': false},
                    );
                    Future<void> delayed =
                        Future.delayed(const Duration(milliseconds: 1));
                    return delayed;
                  }
                },
                onHorizontalDragEnd: (dragEndDetails) async {
                  if (dragEndDetails.primaryVelocity < 0) {
                    // Page forwards
                    await dispatch(
                      StorePageActionCreator.onAddToCart(
                        selectedProduct,
                        productQuantity,
                      ),
                    );
                    dispatch(StorePageActionCreator.onGoToCart());
                  } else if (dragEndDetails.primaryVelocity > 0) {
                    // Page backwards
                    Navigator.of(context).pop();
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 125.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 261.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.selectedProduct != null &&
                                          widget.selectedProduct.name != null
                                      ? widget.selectedProduct.name
                                      : '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 9.0),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "\$$wholeOldSum",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.5),
                                          fontSize: 18.0,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "\$$wholeSum",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 13.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: double.infinity,
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        decoration: BoxDecoration(
                          color: HexColor("#FAFCFF"),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 21),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 307.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Add a ",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: HexColor("#53586F"),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "personal message ",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor("#839BE7"),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "and ",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: HexColor("#53586F"),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "gold finish",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor("#839BE7"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 45.0),
                                if (widget.selectedProduct.engraveAvailable &&
                                    engravingsCount > 0)
                                  Container(
                                    height: 145.0,
                                    width: double.infinity,
                                    constraints:
                                        BoxConstraints(maxWidth: 343.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(0.0, 2.0), // (x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75.0,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              bottomLeft: Radius.circular(12.0),
                                            ),
                                            child: widget.selectedProduct
                                                        .engraveExampleUrl !=
                                                    null
                                                ? CachedNetworkImage(
                                                    imageUrl: selectedProduct
                                                        .engraveExampleUrl,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "images/image-not-found.png",
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Engrave Personal Message",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  "50% Off - One - Time Offer !",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: HexColor("#EB5757"),
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "\$${widget.selectedProduct.engraveOldPrice} ",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: HexColor(
                                                                  "#53586F")
                                                              .withOpacity(.5),
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "\$${widget.selectedProduct.engravePrice}",
                                                        style: TextStyle(
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: HexColor(
                                                              "#53586F"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 9.0),
                                                Container(
                                                  height: 55.0,
                                                  child: ListView.separated(
                                                    itemCount: engravingsCount,
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    separatorBuilder: (_, __) {
                                                      return SizedBox(
                                                          height: 5.0);
                                                    },
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        width: double.infinity,
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: 240.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: HexColor(
                                                              "#FAFCFF"),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22.0),
                                                        ),
                                                        child: TextField(
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.0,
                                                          ),
                                                          maxLength: 20,
                                                          onChanged: (content) {
                                                            setState(() {});
                                                            var engravingListActual =
                                                                List<String>.empty(
                                                                    growable:
                                                                        true);
                                                            for (var i = 0;
                                                                i <
                                                                    engravingControllers
                                                                        .length;
                                                                i++) {
                                                              engravingListActual.add(
                                                                  engravingControllers[
                                                                          i]
                                                                      .text);
                                                            }
                                                            dispatch(StorePageActionCreator
                                                                .onSetEngravingInputs(
                                                                    engravingListActual));
                                                          },
                                                          controller:
                                                              engravingControllers[
                                                                  index],
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            counterText: "",
                                                            hintText:
                                                                'Enter your words here',
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                              top: 7.0,
                                                              bottom: 7.0,
                                                              left: 12.0,
                                                            ),
                                                            hintStyle:
                                                                TextStyle(
                                                              color: HexColor(
                                                                  "#C4C6D2"),
                                                              fontSize: 14.0,
                                                            ),
                                                            enabledBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 20.0),
                                if (widget.selectedProduct
                                    .optionalFinishMaterialEnabled)
                                  Container(
                                    height: 145.0,
                                    width: double.infinity,
                                    constraints:
                                        BoxConstraints(maxWidth: 343.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(0.0, 2.0), // (x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75.0,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              bottomLeft: Radius.circular(12.0),
                                            ),
                                            child: widget.selectedProduct
                                                        .optionalMaterialExampleUrl !=
                                                    null
                                                ? CachedNetworkImage(
                                                    imageUrl: widget
                                                        .selectedProduct
                                                        .optionalMaterialExampleUrl,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "images/image-not-found.png",
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "2.18K Gold Finish",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: HexColor("#53586F"),
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                Text(
                                                  "50% Off - One - Time Offer !",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: HexColor("#EB5757"),
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            "\$${widget.selectedProduct.optionalFinishMaterialOldPrice} ",
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: HexColor(
                                                                  "#53586F")
                                                              .withOpacity(.5),
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            "\$${widget.selectedProduct.optionalFinishMaterialPrice}",
                                                        style: TextStyle(
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: HexColor(
                                                              "#53586F"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 9.0),
                                                Container(
                                                  width: double.infinity,
                                                  height: 32.0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 14.0),
                                                  constraints: BoxConstraints(
                                                    maxWidth: 240.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#FAFCFF"),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.0),
                                                  ),
                                                  child: InkWell(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 32,
                                                          height:
                                                              double.infinity,
                                                          child:
                                                              !optionalMaterialSelected
                                                                  ? SvgPicture
                                                                      .asset(
                                                                      "images/Vector5.svg",
                                                                    )
                                                                  : SvgPicture
                                                                      .asset(
                                                                      "images/Group 170.svg",
                                                                    ),
                                                        ),
                                                        Expanded(
                                                          child: Center(
                                                            child: Text(
                                                              "Add 18K Gold Finish ",
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: HexColor(
                                                                    "#53586F"),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      dispatch(StorePageActionCreator
                                                          .onSetOptionMaterialSelected(
                                                              !optionalMaterialSelected));

                                                      var engravingListActual =
                                                          List<String>.empty(
                                                              growable: true);
                                                      for (var i = 0;
                                                          i <
                                                              engravingControllers
                                                                  .length;
                                                          i++) {
                                                        engravingListActual.add(
                                                            engravingControllers[
                                                                    i]
                                                                .text);
                                                      }
                                                      setState(() {
                                                        optionalMaterialSelected =
                                                            !optionalMaterialSelected;
                                                        engraveInputs =
                                                            engravingListActual;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLostConnection) ConnectionLost(),
        ],
      ),
    );
  }
}
