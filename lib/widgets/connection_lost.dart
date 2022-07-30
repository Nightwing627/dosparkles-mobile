import 'package:flutter/material.dart';

class ConnectionLost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 25.0,
          color: Colors.black.withOpacity(.8),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off,
                  color: Colors.white,
                  size: 14.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  "No internet connection",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
