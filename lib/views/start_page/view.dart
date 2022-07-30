import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:com.floridainc.dosparkles/actions/adapt.dart';
import 'package:com.floridainc.dosparkles/widgets/keepalive_widget.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/sparkles_drawer.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    StartPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    _FirstPage(
        continueTapped: () => dispatch(StartPageActionCreator.onStart())),
  ];

  Widget _buildPage(Widget page) {
    return keepAliveWrapper(page);
  }

  Future<double> _checkContextInit(Stream<double> source) async {
    await for (double value in source) {
      if (value > 0) {
        return value;
      }
    }
    return 0.0;
  }

  return Builder(
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "images/image 37.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "images/image 38.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Scaffold(
            body: FutureBuilder(
              future: _checkContextInit(
                Stream<double>.periodic(Duration(milliseconds: 50),
                    (x) => MediaQuery.of(viewService.context).size.height),
              ),
              builder: (_, snapshot) {
                if (snapshot.hasData) if (snapshot.data > 0) {
                  Adapt.initContext(viewService.context);
                  if (state.isFirstTime != true)
                    return Container();
                  else
                    return PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: state.pageController,
                      allowImplicitScrolling: false,
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(pages[index]);
                      },
                    );
                }
                return Container();
              },
            ),
            backgroundColor: Colors.transparent,
            drawer: SparklesDrawer(),
            bottomNavigationBar: Container(
              height: 100.0,
              color: Colors.transparent,
              padding: EdgeInsets.only(bottom: 26.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 48.0,
                  constraints: BoxConstraints(maxWidth: 300.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(31.0),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(6.0),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shadowColor: MaterialStateProperty.all(Colors.grey[300]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0),
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: HexColor("#6092DC"),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset("images/Vector.svg"),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      dispatch(StartPageActionCreator.onStart());
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _FirstPage extends StatelessWidget {
  final Function continueTapped;
  const _FirstPage({this.continueTapped});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}
