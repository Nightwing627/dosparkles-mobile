import 'dart:ui';

import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/models/number_format_model.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../actions/api/graphql_client.dart';
import '../../utils/colors.dart';
import 'state.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

void _onSubmit(BuildContext context, String fullValue) async {
  AppUser globalUser = GlobalStore.store.getState().user;

  String formattedValue = fullValue.replaceAll(new RegExp('[^0-9]'), "");
  try {
    await BaseGraphQLClient.instance
        .setUserPhoneNumber(globalUser.id, formattedValue);

    globalUser.phoneNumber = fullValue;
    GlobalStore.store.dispatch(GlobalActionCreator.setUser(globalUser));

    Navigator.of(context).pop();
  } catch (e) {
    print(e);
  }
}

Widget buildView(
  AddPhonePageState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  Adapt.initContext(viewService.context);
  return _MainBody();
}

class _MainBody extends StatefulWidget {
  @override
  __MainBodyState createState() => __MainBodyState();
}

class __MainBodyState extends State<_MainBody> {
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

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: HexColor("#F2F6FA"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/background_lines_top.png",
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/background_lines_bottom.png",
                fit: BoxFit.contain,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                centerTitle: true,
                elevation: 0.0,
                leadingWidth: 70.0,
                automaticallyImplyLeading: false,
                leading: null,
                backgroundColor: Colors.transparent,
                title: Text(
                  "Add Phone",
                  style: TextStyle(
                    fontSize: 22,
                    color: HexColor("#53586F"),
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.enable('smcp')],
                  ),
                ),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: _InnerPart(),
              ),
            ),
            if (_isLostConnection) ConnectionLost(),
          ],
        ),
      ),
    );
  }
}

class _InnerPart extends StatefulWidget {
  @override
  __InnerPartState createState() => __InnerPartState();
}

class __InnerPartState extends State<_InnerPart> {
  final formKey = GlobalKey<FormState>();
  String fullValue = '';
  String phone = '';

  _setPhoneValue(value, countryCode) {
    setState(() {
      phone = value;
      fullValue = "+$countryCode $value";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height -
            Scaffold.of(context).appBarMaxHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "1.Prizes are sent via SMS.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3.0),
                Text(
                  "2.We don't share or you. Ever.",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.10,
              ),
              child: _CountryPickerDropdown(
                context: context,
                setPhoneValue: (val, countryCode) =>
                    _setPhoneValue(val, countryCode),
                formKey: formKey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.30,
              ),
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
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: phone.length == 0
                      ? null
                      : () {
                          if (formKey.currentState.validate()) {
                            _onSubmit(context, fullValue);
                          }
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryPickerDropdown extends StatefulWidget {
  final BuildContext context;
  final Function setPhoneValue;
  final formKey;

  _CountryPickerDropdown({
    Key key,
    this.context,
    this.setPhoneValue,
    this.formKey,
  }) : super(key: key);

  @override
  __CountryPickerDropdownState createState() => __CountryPickerDropdownState();
}

class __CountryPickerDropdownState extends State<_CountryPickerDropdown> {
  USCodePhoneNumberMask numberMask = USCodePhoneNumberMask(
    formatter: MaskTextInputFormatter(mask: "(###) ###-####"),
    validator: (value) {
      if (value != null && value.length < 14) {
        return 'Should be at least 8 characters';
      }
      return null;
    },
  );

  USCodePhoneNumberMask numberMaskOther = USCodePhoneNumberMask(
    formatter: MaskTextInputFormatter(mask: "####-####-####-####"),
    validator: (value) {
      if (value != null && value.length < 14) {
        return 'Should be at least 14 characters';
      }
      return null;
    },
  );

  double dropdownButtonWidth;
  double dropdownItemWidth;
  String countryCode = '1';

  @override
  void initState() {
    super.initState();
    dropdownButtonWidth = MediaQuery.of(widget.context).size.width * 0.34;
    dropdownItemWidth = MediaQuery.of(widget.context).size.width / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            itemHeight: null,
            isDense: false,
            icon: Container(
              padding: EdgeInsets.only(left: 0, top: 8, right: 5, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Icon(Icons.keyboard_arrow_down),
            ),
            selectedItemBuilder: (Country country) =>
                _buildDropdownSelectedItemBuilder(country),
            itemBuilder: (Country country) =>
                _buildDropdownItem(country, dropdownItemWidth),
            initialValue: 'US',
            onValuePicked: (Country country) {
              setState(() {
                countryCode = country.phoneCode;
              });
            },
          ),
        ),
        Expanded(
          child: Form(
            key: widget.formKey,
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (String value) {
                widget.setPhoneValue(value, countryCode);
              },
              inputFormatters: [
                countryCode == '1'
                    ? numberMask.formatter
                    : numberMaskOther
                        .formatter // FilteringTextInputFormatter.digitsOnly
              ],
              validator: countryCode == '1'
                  ? numberMask.validator
                  : numberMaskOther.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: "Add Phone",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black26,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#C4C6D2")),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: HexColor("#C4C6D2")),
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        )
      ],
    );
  }
}

Widget _buildDropdownSelectedItemBuilder(Country country) {
  return Container(
    padding: EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
    ),
    child: CountryPickerUtils.getDefaultFlagImage(country),
  );
}

Widget _buildDropdownItem(Country country, double dropdownItemWidth) {
  return SizedBox(
    width: dropdownItemWidth,
    child: Row(
      children: [
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
      ],
    ),
  );
}
