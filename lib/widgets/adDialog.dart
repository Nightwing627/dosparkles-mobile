import 'dart:ui';

import 'package:com.floridainc.dosparkles/utils/colors.dart';
import 'package:flutter/material.dart';

Future<bool> addDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: EdgeInsets.only(left: 14.0, right: 14.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: double.infinity,
                  constraints: BoxConstraints(maxHeight: 496.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                "images/image_2021_04_22T16_28_47_549Z 3.png",
                                width: double.infinity,
                                height: 265.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              bottom: -30.0,
                              right: -20.0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Image.asset(
                                  "images/Group 295.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              bottom: 19.0,
                              right: 5.0,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "One-time offer".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          constraints: BoxConstraints(maxWidth: 266.0),
                          child: Text(
                            "Add a Mahogany - style Luxury Gift box",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: HexColor("#53586F"),
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "\$39,95",
                                style: TextStyle(
                                  color: HexColor("#53586F"),
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "\$79,95",
                                style: TextStyle(
                                  color: HexColor("#53586F").withOpacity(.5),
                                  fontSize: 18.0,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          "50% OFF",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: HexColor("#EB5757"),
                          ),
                        ),
                        SizedBox(height: 11.0),
                        Container(
                          width: double.infinity,
                          height: 48.0,
                          constraints: BoxConstraints(maxWidth: 266.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  HexColor("#27AE60")),
                              elevation: MaterialStateProperty.all(0.0),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Yes, I’ll take it",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(height: 13.0),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Text(
                            "No, thanks",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: HexColor("#53586F"),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(height: 14.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -18.0,
                  right: -11.0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          "images/close_button_terms.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
