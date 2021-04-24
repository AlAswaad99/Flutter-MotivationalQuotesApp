import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivate_linux/model/quotes.dart';
import 'package:motivate_linux/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/bloc/favorite_bloc.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/localization/lang_switcher.dart';
import 'package:motivate_linux/localization/localizaton.dart';
import 'package:motivate_linux/model/language.dart';
import 'package:motivate_linux/motivation_app_routes.dart';
import 'package:motivate_linux/pages/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher,
  );
  Workmanager.registerPeriodicTask("trial_7th", "notification_7th",
      frequency: Duration(minutes: 15), initialDelay: Duration(seconds: 15));
  final curlang = await NotificationServices.getCurrentLanguage();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MotivateApp(
      language: curlang,
      initiateApp: true,
    ));
  });
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('launcher_icon');
    var iOS = new IOSInitializationSettings();

    var settings = new InitializationSettings(android: android, iOS: iOS);
    flip.initialize(settings);
    await _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  final quotes = await QuoteDataProvider().readJSON();
  final index = 0 + Random().nextInt((45));

  final language = await NotificationServices.getCurrentLanguage();

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  if (language.languageCode == "am") {
    await flip.show(0, "${quotes[index].amhperson}",
        "${quotes[index].amhversion}", platformChannelSpecifics);
  } else {
    await flip.show(0, "${quotes[index].engperson}",
        "${quotes[index].engversion}", platformChannelSpecifics);
    // }
  }
}

class MotivateApp extends StatefulWidget {
  final Language language;
  bool initiateApp;
  MotivateApp({this.language, this.initiateApp});
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
  Language language;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final quoteDataProvider = QuoteDataProvider();
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuoteBloc>(
            create: (context) => QuoteBloc(quoteDataProvider: quoteDataProvider)
              ..add(FetchQuoteEvent())),
        BlocProvider<FavoriteBloc>(create: (context) => FavoriteBloc())
      ],
      child: MaterialApp(
        onGenerateRoute: MotivationAppRoute.generateRoute,
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
          if (widget.initiateApp && widget.language.languageCode == "am") {
            widget.initiateApp = false;
            return supportedlocale.last;
          }
          for (var locale in supportedlocale) {
            if (locale.languageCode == devicelocale.languageCode) {
              return devicelocale;
            }
          }
          return supportedlocale.first;
        },
        theme: ThemeData(
          fontFamily: 'Geogrotesque',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ShowCaseWidget(
            builder: Builder(
          builder: (context) => HomePage(
            language: widget.language,
          ),
        )),
      ),
    );
  }
}

// class NotificationServices {

//   static Future<Language> getCurrentLanguage() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     String currentLocale = preferences.getString("currentLocale");
//     if (currentLocale == "en" || currentLocale == null) {
//       return Language.languageList()[1];
//     }
//     return Language.languageList()[0];
//   }
// }
