import 'package:flutter/material.dart';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

TimeOfDay timeConvert(String normTime, {bool amPm = false}) {
  if (amPm == false) {
    TimeOfDay time = TimeOfDay(
        hour: int.parse(normTime.split(":")[0]),
        minute: int.parse(normTime.split(":")[1]));
    return time;
  } else {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}

double checkDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is String) {
    return double.parse(value);
  } else {
    return value + 0.0;
  }
}
