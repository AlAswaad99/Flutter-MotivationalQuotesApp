import 'dart:math';

import 'package:flutter/material.dart';
import 'package:motivate_linux/model/quotes.dart';
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
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerPeriodicTask("5", "motivateAppNoification",
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(hours: 24),
      initialDelay: Duration(seconds: 5));
  runApp(MotivateApp());
}

void callbackDispatcher() async {
  Workmanager.executeTask((taskName, inputData) async {
    var androidInitialize = AndroidInitializationSettings('launcher_icon');
    var iOSInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin motivateAppNotification =
        FlutterLocalNotificationsPlugin();
    motivateAppNotification.initialize(initializationSettings,
        onSelectNotification: NotificationServices().notficationSelected);
    List<Quote> quotes = await QuoteDataProvider().readJSON();
    int index = 0 + Random().nextInt((quotes.length));

    NotificationServices()
        .displayNotification(quotes[index], motivateAppNotification);
    return Future.value(true);
  });
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
    // String title;

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
      // ),
    );
  }
}

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

    //
    // var timeofday = TimeOfDay(hour: 15, minute: 37);
    // var scheduledTime = DateTime(timeofday.hour, timeofday.minute);

    // await motivateAppNotification.sh(0, "Trial Motivate App",
    //     "please work", scheduledTime, generalNotitficationDetails,
    //     androidAllowWhileIdle: true);
    //
    // await motivateAppNotification.periodicallyShow(
    //     0, "title", "body", RepeatInterval.daily, generalNotitficationDetails,
    //     androidAllowWhileIdle: true);
  }
}
