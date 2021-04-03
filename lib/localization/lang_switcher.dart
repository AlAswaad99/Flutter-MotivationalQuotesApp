import 'package:flutter/cupertino.dart';
import 'package:motivate_linux/model/language.dart';

class LanguageSwitch {
  static Locale changeLanguage(Language language) {
    Locale _temp;
    switch (language.languageCode) {
      case "en":
        _temp = Locale(language.languageCode);
        break;
      case "am":
        _temp = Locale(language.languageCode);
        break;

      default:
        _temp = Locale(language.languageCode);
    }
    return _temp;
  }
}
