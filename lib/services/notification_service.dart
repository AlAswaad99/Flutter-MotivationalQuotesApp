import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:motivate_linux/model/quotes.dart';

class NotificationServices {
  Future notficationSelected(String payload) async {}

  Future displayNotification(Quote quote,
      FlutterLocalNotificationsPlugin motivateAppNotification) async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Motivation App", "Today's Quote is...",
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalNotitficationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await motivateAppNotification.show(0, "${quote.engperson}",
        "${quote.engversion}", generalNotitficationDetails);
  }
}
