import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/widgets/connection_lost.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import '../../utils/colors.dart';
import 'state.dart';

Widget buildView(
    CustomizeLinkPageState state, Dispatch dispatch, ViewService viewService) {
  Adapt.initContext(viewService.context);
  return MainPage();
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Customize Link"),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [HexColor('#3D9FB0'), HexColor('#557084')],
                  begin: const FractionalOffset(0.5, 0.5),
                  end: const FractionalOffset(0.5, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
          body: Container(
            color: HexColor('#3D9FB0'),
            width: double.infinity,
            height: double.infinity,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your current referral link:"),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Text("dosparckles.com/"),
                            Expanded(
                              child: Container(
                                height: 40,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'DOVID',
                                    hintStyle: TextStyle(fontSize: 18),
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ButtonTheme(
                            minWidth: 220.0,
                            height: 45.0,
                            child: OutlineButton(
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              shape: StadiumBorder(),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                              onPressed: () => null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLostConnection) ConnectionLost(),
      ],
    );
  }
}
