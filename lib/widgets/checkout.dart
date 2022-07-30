import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:com.floridainc.dosparkles/views/cart_page/action.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

void _saveFieldsInfo(
  String addressValue,
  String apartmentValue,
  String firstNameValue,
  String lastNameValue,
  bool checkboxValue,
) async {
  SharedPreferences.getInstance().then((_p) {
    _p.setString("checkoutAddress", addressValue);
    _p.setString("checkoutApartment", apartmentValue);
    _p.setString("checkoutFirstName", firstNameValue);
    _p.setString("checkoutLastName", lastNameValue);
    _p.setBool("checkoutSaveForNextTime", checkboxValue);
  });
}

class Checkout extends StatefulWidget {
  final Dispatch dispatch;

  Checkout({this.dispatch});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
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

  final _formKey1 = GlobalKey<FormState>();
  final _cardForm = GlobalKey<FormState>();

  bool isNextPage = false;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  bool _isLoading = false;

  void _setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_RZ5vq09GA2ZJdUZMjIykRGIQ", // "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
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
          Scaffold(
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
                "Checkout",
                style: TextStyle(
                  fontSize: 22,
                  color: HexColor("#53586F"),
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.enable('smcp')],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: double.infinity,
              constraints: BoxConstraints(maxHeight: 87.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0.0, -0.2), // (x, y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  width: 300.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
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
                    child: _isLoading
                        ? Container(
                            width: 25.0,
                            height: 25.0,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            isNextPage ? "Pay now" : 'Continue To Payment',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (isNextPage == false) {
                              if (_formKey1.currentState.validate()) {
                                setState(() {
                                  isNextPage = true;
                                });
                              }
                            } else {
                              if (_cardForm.currentState.validate()) {
                                _setIsLoading(true);
                                List<String> expiryDateSplitted =
                                    expiryDate.split("/");

                                final CreditCard cardSchema = CreditCard(
                                  number: cardNumber,
                                  expMonth: int.parse(expiryDateSplitted[0]),
                                  expYear: int.parse(expiryDateSplitted[1]),
                                  cvc: cvvCode,
                                );

                                Token _paymentToken =
                                    await StripePayment.createTokenWithCard(
                                        cardSchema);

                                if (_paymentToken != null &&
                                    _paymentToken.tokenId != null) {
                                  await widget.dispatch(
                                    CartPageActionCreator.onSetPaymentToken(
                                        _paymentToken.tokenId.toString()),
                                  );
                                }

                                widget.dispatch(
                                  CartPageActionCreator.onProceedToCheckout(),
                                );

                                //  _setIsLoading(false);

                                // addDialog(context);
                              }
                            }
                          },
                  ),
                ),
              ),
            ),
            body: Builder(builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: !isNextPage
                    ? _InnerPart(formKey: _formKey1)
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              Scaffold.of(context).appBarMaxHeight,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "images/Group 203.png",
                                          color: Colors.white.withOpacity(.2),
                                        ),
                                        Dash(
                                          direction: Axis.horizontal,
                                          length: 210,
                                          dashLength: 10,
                                          dashColor: HexColor("#C4C6D2"),
                                        ),
                                        Image.asset("images/Group 203.png"),
                                      ],
                                    ),
                                    SizedBox(height: 7.0),
                                    Container(
                                      width: 320.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Shipping info",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              foreground: Paint()
                                                ..shader = LinearGradient(
                                                  colors: [
                                                    HexColor('#CBD3FD'),
                                                    HexColor('#5d74bc')
                                                  ],
                                                  begin: const FractionalOffset(
                                                      0.0, 0.0),
                                                  end: const FractionalOffset(
                                                      1.0, 0.0),
                                                  stops: [0.0, 1.0],
                                                  tileMode: TileMode.clamp,
                                                ).createShader(Rect.fromLTWH(
                                                    0.0, 0.0, 200.0, 70.0)),
                                            ),
                                          ),
                                          Text(
                                            "Payment info",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              foreground: Paint()
                                                ..shader = LinearGradient(
                                                  colors: [
                                                    HexColor('#CBD3FD'),
                                                    HexColor('#5d74bc')
                                                  ],
                                                  begin: const FractionalOffset(
                                                      0.0, 0.0),
                                                  end: const FractionalOffset(
                                                      1.0, 0.0),
                                                  stops: [0.0, 1.0],
                                                  tileMode: TileMode.clamp,
                                                ).createShader(
                                                  Rect.fromLTWH(
                                                      0.0, 0.0, 200.0, 70.0),
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.0),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(bottom: 20.0),
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
                                child: CreditCardForm(
                                  formKey: _cardForm,
                                  obscureCvv: true,
                                  obscureNumber: false,
                                  cardHolderDecoration: InputDecoration(
                                    hintText: 'Enter your cardholder name',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black26,
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Cardholder Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      height: 0.7,
                                      fontSize: 22,
                                    ),
                                  ),
                                  cardNumberDecoration: InputDecoration(
                                    hintText: 'Enter ',
                                    prefix: Container(
                                      padding: EdgeInsetsDirectional.only(
                                          end: 8.0, top: 0),
                                      child: Image.asset(
                                        "images/high-quality-images/Group 208.png",
                                        width: 20.0,
                                        height: 20.0,
                                        alignment: Alignment.bottomCenter,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(bottom: 5.0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black26,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Card Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      height: 0.7,
                                      fontSize: 22,
                                    ),
                                  ),
                                  expiryDateDecoration: InputDecoration(
                                    hintText: 'Enter date',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black26,
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'Expiry date',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      height: 0.7,
                                      fontSize: 22,
                                    ),
                                  ),
                                  cvvCodeDecoration: InputDecoration(
                                    hintText: 'Enter CVV',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: HexColor("#C4C6D2")),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black26,
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelText: 'CVV',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      height: 0.7,
                                      fontSize: 22,
                                    ),
                                  ),
                                  onCreditCardModelChange:
                                      onCreditCardModelChange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              );
            }),
          ),
          if (_isLostConnection) ConnectionLost(),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}

class _InnerPart extends StatefulWidget {
  final formKey;

  _InnerPart({this.formKey});

  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  TextEditingController addressValue;
  TextEditingController apartmentValue;
  TextEditingController firstNameValue;
  TextEditingController lastNameValue;
  bool checkboxValue = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((_p) {
      setState(() {
        addressValue =
            TextEditingController(text: _p.getString("checkoutAddress"));
        apartmentValue =
            TextEditingController(text: _p.getString("checkoutApartment"));
        firstNameValue =
            TextEditingController(text: _p.getString("checkoutFirstName"));
        lastNameValue =
            TextEditingController(text: _p.getString("checkoutLastName"));
        checkboxValue = _p.getBool("checkoutSaveForNextTime") ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("images/Group 203.png"),
                      Dash(
                        direction: Axis.horizontal,
                        length: 210,
                        dashLength: 10,
                        dashColor: HexColor("#C4C6D2"),
                      ),
                      Image.asset("images/Group 204.png"),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Container(
                    width: 320.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  HexColor('#CBD3FD'),
                                  HexColor('#5d74bc')
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ).createShader(
                                  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          ),
                        ),
                        Text(
                          "Payment info",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: HexColor("#C4C6D2"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.0),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              // setState(() => firstNameValue = value);
                            },
                            controller: firstNameValue,
                            decoration: InputDecoration(
                              hintText: 'Enter here',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#C4C6D2")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#C4C6D2")),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'First Name',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                height: 0.7,
                                fontSize: 22,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 23),
                        Flexible(
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,
                            controller: lastNameValue,
                            onChanged: (value) {
                              // setState(() => lastNameValue = value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter here',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#C4C6D2")),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: HexColor("#C4C6D2")),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black26,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Last Name',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                height: 0.7,
                                fontSize: 22,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Field must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        // setState(() => addressValue = value);
                      },
                      controller: addressValue,
                      decoration: InputDecoration(
                        hintText: 'Enter your address',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          height: 0.7,
                          fontSize: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field must not be empty';
                        }
                        return null;
                      },
                    ),
                    // SizedBox(height: 10.0),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.all(14.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(4.0),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey[300],
                    //         offset: Offset(0.0, 2.0), // (x, y)
                    //         blurRadius: 5.0,
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "4913, Sugar Pine, Boca Raton",
                    //         style: TextStyle(
                    //           fontSize: 16.0,
                    //           fontWeight: FontWeight.w600,
                    //           color: HexColor("#0F142B"),
                    //         ),
                    //       ),
                    //       SizedBox(height: 6.0),
                    //       Text(
                    //         "Florida, United Stated",
                    //         style: TextStyle(
                    //           fontSize: 14.0,
                    //           color: HexColor("#0F142B"),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        // setState(() => addressValue = value);
                      },
                      controller: apartmentValue,
                      decoration: InputDecoration(
                        hintText: 'Enter your apartment',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: HexColor("#C4C6D2")),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Apartment',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          height: 0.7,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(height: 23),
                    Row(
                      children: [
                        SizedBox(
                          height: 16.0,
                          width: 16.0,
                          child: Checkbox(
                            value: checkboxValue,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (bool value) {
                              setState(() {
                                checkboxValue = value;
                              });

                              if (checkboxValue) {
                                _saveFieldsInfo(
                                  addressValue.text.toString(),
                                  apartmentValue.text.toString(),
                                  firstNameValue.text.toString(),
                                  lastNameValue.text.toString(),
                                  checkboxValue,
                                );
                              } else {
                                _saveFieldsInfo('', '', '', '', false);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 13),
                        Text(
                          'Save this information for next time',
                          style: TextStyle(fontSize: 13.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 23.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
