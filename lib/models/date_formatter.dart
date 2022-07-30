import 'package:intl/intl.dart';

class DateFormatter {
  String getFormattedChatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    DateTime justNow = DateTime.now().subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();
    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just now';
    }

    String roughTimeString = DateFormat('jm').format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return 'YDA, ' + roughTimeString;
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '${weekday.substring(0, 3)}, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
