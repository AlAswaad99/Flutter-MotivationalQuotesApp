import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/pages/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MotivateApp());
}

class MotivateApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MotivateAppState state =
        context.findAncestorStateOfType<_MotivateAppState>();
    state.setLocale(locale);
  }

  @override
  _MotivateAppState createState() => _MotivateAppState();
}

class _MotivateAppState extends State<MotivateApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title;

    final quoteDataProvider = QuoteDataProvider();
    return BlocProvider<QuoteBloc>(
      create: (context) => QuoteBloc(quoteDataProvider: quoteDataProvider)
        ..add(FetchQuoteEvent()),
      child: MaterialApp(
          locale: _locale,
          debugShowCheckedModeBanner: false,
          title: 'Motivational Quotes',
          supportedLocales: [
            Locale('en', 'US'),
            Locale('am', ''),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            MotivateAppLocalization.delegate,
          ],
          localeResolutionCallback: (devicelocale, supportedlocale) {
            for (var locale in supportedlocale) {
              if (locale.languageCode == devicelocale.languageCode) {
                return devicelocale;
              }
            }
            return supportedlocale.first;
          },
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage()),
    );
  }
}
