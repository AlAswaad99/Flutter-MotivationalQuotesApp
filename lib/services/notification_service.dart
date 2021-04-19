import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  Language language;

  Future notficationSelected(String payload) async {}

  Future displayNotification(Quote quote,
      FlutterLocalNotificationsPlugin motivateAppNotification) async {
    var androidDetails = AndroidNotificationDetails(
        "channelId", "Motivation App", "Today's Quote is...",
        importance: Importance.max, priority: Priority.high);
    var iOSDetails = IOSNotificationDetails();
    var generalNotitficationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await getCurrentLanguage().then((value) => language = value);

    if (language.languageCode == "am") {
      await motivateAppNotification.show(0, "${quote.amhperson}",
          "${quote.amhversion}", generalNotitficationDetails);
    } else {
      await motivateAppNotification.show(0, "${quote.engperson}",
          "${quote.engversion}", generalNotitficationDetails);
    }
    await motivateAppNotification.show(0, "${quote.engperson}",
        "${quote.engversion}", generalNotitficationDetails);
  }

  Future<Language> getCurrentLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentLocale = preferences.getString("currentLocale");
    if (currentLocale == "en" || currentLocale == null) {
      return Language.languageList()[1];
    }
    return Language.languageList()[0];
  }
}
