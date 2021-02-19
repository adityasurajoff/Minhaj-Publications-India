import 'dart:io';
import 'package:intl/intl.dart';

checkConnection() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}

String dateParser(String date) {
  DateTime dateTime = DateTime.parse(date);
  var diff = DateTime.now().difference(dateTime);
  if (diff.inSeconds <= 60) {
    return diff.inSeconds.toString() + " sec ago";
  } else if (diff.inMinutes <= 60) {
    return diff.inMinutes.toString() + " min ago";
  } else if (diff.inHours <= 24) {
    return diff.inHours.toString() + " hour ago";
  } else if (diff.inDays <= 7) {
    return diff.inDays.toString() + " day ago";
  } else {
    return " ${DateFormat().add_yMMMd().format(dateTime)}";
  }
}
