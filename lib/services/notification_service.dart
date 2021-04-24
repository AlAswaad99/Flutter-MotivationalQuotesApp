import 'package:motivate_linux/model/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  static Future<Language> getCurrentLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentLocale = preferences.getString("currentLocale");
    if (currentLocale == "en" || currentLocale == null) {
      return Language.languageList()[1];
    }
    return Language.languageList()[0];
  }
}
