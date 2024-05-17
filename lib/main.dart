import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:poll_app/extensions/string_extension.dart';
import 'package:poll_app/utils/routing_handler.dart';
import 'package:poll_app/views/add_question_view.dart';
import 'package:poll_app/views/create_poll_view.dart';
import 'package:poll_app/views/home_view.dart';
import 'package:poll_app/views/not_found_view.dart';
import 'package:poll_app/views/poll_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //does not work for web??
  final String themeString = await rootBundle.loadString('theme/theme.json');
  final dynamic themeJSON = jsonDecode(themeString);
  final ThemeData? themeData = ThemeDecoder.decodeThemeData(themeJSON);

  runApp(MyApp(theme: themeData));
}

class MyApp extends StatelessWidget {
  final ThemeData? theme;

  MyApp({super.key, required this.theme});

  static const String homeRoute = '/';
  static const String createPoll = '/createPoll';
  static const String addQuestion = '/addQuestion';
  static const String pollDetail = '/pollDetail';

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: onGenerateRoute);
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    RoutingData routingData = settings.name!.getRoutingData;

    switch (routingData.route) {
      case homeRoute:
        return MaterialPageRoute(
            builder: (context) => const HomeView(), settings: settings);
      case createPoll:
        return MaterialPageRoute(
            builder: (context) => const CreatePollView(), settings: settings);
      case addQuestion:
        return MaterialPageRoute(
            builder: (context) => const AddQuestionView(), settings: settings);
      case pollDetail:
        return MaterialPageRoute(
            builder: (context) => PollDetailView(
                  pollId: routingData['pollId'],
                ),
            settings: settings);
      default:
        return MaterialPageRoute(
            builder: (context) => const NotFoundView(), settings: settings);
    }
  }
}
