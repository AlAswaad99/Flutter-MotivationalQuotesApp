import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MotivateAppLocalization {
  MotivateAppLocalization(this.locale);

  final Locale locale;
  Map<String, String> _localizedValues;

  static MotivateAppLocalization of(BuildContext context) {
    return Localizations.of<MotivateAppLocalization>(
        context, MotivateAppLocalization);
  }

  Future load() async {
    String response =
        await rootBundle.loadString("assets/lang/${locale.languageCode}.json");

    Map<String, dynamic> mappedValues = json.decode(response);

    _localizedValues =
        mappedValues.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) => _localizedValues[key];

  static const LocalizationsDelegate<MotivateAppLocalization> delegate =
      _MotivateAppLocalizationDelegates();
}

class _MotivateAppLocalizationDelegates
    extends LocalizationsDelegate<MotivateAppLocalization> {
  const _MotivateAppLocalizationDelegates();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'am'].contains(locale.languageCode);
  }

  @override
  Future<MotivateAppLocalization> load(Locale locale) async {
    MotivateAppLocalization localization = MotivateAppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<MotivateAppLocalization> old) =>
      false;
}
