import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motivate_linux/bloc/bloc.dart';
import 'package:motivate_linux/dataprovider/quote_data.dart';
import 'package:motivate_linux/pages/homepage.dart';

void main() {
  runApp(MotivateApp());
}

class MotivateApp extends StatefulWidget {
  @override
  _MotivateAppState createState() => _MotivateAppState();
}

class _MotivateAppState extends State<MotivateApp> {
  @override
  Widget build(BuildContext context) {
    final quoteDataProvider = QuoteDataProvider();
    return BlocProvider<QuoteBloc>(
      create: (context) => QuoteBloc(quoteDataProvider: quoteDataProvider)
        ..add(FetchQuoteEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Motivational Quotes/ገንቢ ንግግሮች',
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
        home: HomePage(title: 'Motivational Quotes/ገንቢ ንግግሮች'),
      ),
    );
  }
}
