import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBarWidget extends StatefulWidget {
  final prefsData;
  final initialIndex;
  final isTransparentBackground;

  BottomNavBarWidget({
    Key key,
    this.prefsData,
    this.initialIndex = 0,
    this.isTransparentBackground = false,
  }) : super(key: key);

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;
  List _valuesList = [];
  bool _isUpdated = false;
  int _updatedChatsCount = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      var globalState = GlobalStore.store.getState();
      var storeFavorite = globalState.user.storeFavorite;

      if (storeFavorite != null)
        Navigator.of(context).pushReplacementNamed('storepage');
      else
        Navigator.of(context).pushReplacementNamed('storeselectionpage');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('chatpage');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('invite_friendpage');
    }
  }

  void getChatsMap() {
    if (widget.prefsData != null) {
      setState(() => _valuesList = []);

      for (var item in widget.prefsData.values) {
        if (item is Map) {
          _valuesList.add(item['checked']);
        }
      }

      if (_valuesList.length > 0) {
        bool isNotUpdated = _valuesList.every((element) => element == true);
        int count =
            _valuesList.where((element) => element == false).toList().length;

        if (isNotUpdated) {
          setState(() {
            _isUpdated = false;
            _updatedChatsCount = 0;
          });
        } else {
          setState(() {
            _isUpdated = true;
            _updatedChatsCount = count;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    getChatsMap();
  }

  @override
  void didUpdateWidget(covariant BottomNavBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
    getChatsMap();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            widget.isTransparentBackground ? Colors.transparent : Colors.white,
        boxShadow: widget.isTransparentBackground
            ? null
            : [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(0.0, -2.0),
                  blurRadius: 10.0,
                )
              ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: SvgPicture.asset(
              'images/Vector (1)121.svg',
              fit: BoxFit.contain,
              height: 23.0,
            ),
            activeIcon: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: HexColor("#6092DC").withOpacity(.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'images/Vector (1)121.svg',
                  fit: BoxFit.contain,
                  height: 23.0,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  'images/0 notification.svg',
                  fit: BoxFit.contain,
                  height: 23.0,
                ),
                _isUpdated == true && _updatedChatsCount != 0
                    ? Positioned.fill(
                        top: -1.8,
                        right: 2.0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: HexColor("#6092DC"),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "$_updatedChatsCount",
                                style: TextStyle(
                                  fontSize: 7.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(child: null),
              ],
            ),
            activeIcon: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: HexColor("#6092DC").withOpacity(.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'images/0 notification.svg',
                  fit: BoxFit.contain,
                  height: 23.0,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: SvgPicture.asset(
              'images/Group 25324245.svg',
              fit: BoxFit.contain,
              height: 23.0,
            ),
            activeIcon: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: HexColor("#6092DC").withOpacity(.1),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'images/Group 25324245.svg',
                  fit: BoxFit.contain,
                  height: 23.0,
                ),
              ),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
