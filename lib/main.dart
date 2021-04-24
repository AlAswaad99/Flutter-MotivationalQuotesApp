import 'dart:math';

import 'package:flutter/material.dart';
import 'package:motivate_linux/model/quotes.dart';
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
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
  // Periodic task registration
  Workmanager.registerPeriodicTask(
      "trial_6th",

      //This is the value that will be
      // returned in the callbackDispatcher
      "notification_6th",

      // When no frequency is provided
      // the default 15 minutes is set.
      // Minimum frequency is 15 min.
      // Android will automatically change
      // your frequency to 15 min
      // if you have configured a lower frequency.
      frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 5));
  final curlang = await NotificationServices.getCurrentLanguage();
  runApp(MotivateApp(
    language: curlang,
    initiateApp: true,
  ));
}

// void callbackDispatcher() {
//   Workmanager.executeTask((taskName, inputData) {
//     Language language;

//     var androidInitialize = AndroidInitializationSettings('launcher_icon');
//     var iOSInitialize = IOSInitializationSettings();
//     var initializationSettings =
//         InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     FlutterLocalNotificationsPlugin motivateAppNotification =
//         FlutterLocalNotificationsPlugin();
//     motivateAppNotification.initialize(initializationSettings,
//         onSelectNotification: NotificationServices().notficationSelected);
//     var quotes;

//     QuoteDataProvider().readJSON().then((value) => quotes = value);
//     final index = 0 + Random().nextInt((quotes.length));

//     var androidDetails = AndroidNotificationDetails(
//         "channelId", "Motivation App", "Today's Quote is...",
//         importance: Importance.max, priority: Priority.high);
//     var iOSDetails = IOSNotificationDetails();
//     var generalNotitficationDetails =
//         NotificationDetails(android: androidDetails, iOS: iOSDetails);

//     NotificationServices.getCurrentLanguage().then((value) => language = value);

//     if (language.languageCode == "am") {
//       motivateAppNotification.show(0, "${quotes[index].amhperson}",
//           "${quotes[index].amhversion}", generalNotitficationDetails);
//     } else {
//       motivateAppNotification.show(0, "${quotes[index].engperson}",
//           "${quotes[index].engversion}", generalNotitficationDetails);
//     }
//     motivateAppNotification.show(0, "${quotes[index].engperson}",
//         "${quotes[index].engversion}", generalNotitficationDetails);

//     return Future.value(true);
//   });
// }

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('launcher_icon');
    var iOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: iOS);
    flip.initialize(settings);
    await _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
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

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  // // // await flip.show(
  // // //     0,
  // // //     'GeeksforGeeks',
  // // //     'Your are one step away to connect with GeeksforGeeks',
  // // //     platformChannelSpecifics,
  // // //     payload: 'Default_Sound');

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
    String title;

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

Future displayNotification(Quote quote,
    FlutterLocalNotificationsPlugin motivateAppNotification) async {}

class NotificationServices {
  Future notficationSelected(String payload) async {}

  static Future<Language> getCurrentLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentLocale = preferences.getString("currentLocale");
    if (currentLocale == "en" || currentLocale == null) {
      return Language.languageList()[1];
    }
    return Language.languageList()[0];
  }
}
