import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:poll_app/views/add_question_view.dart';
import 'package:poll_app/views/create_poll_view.dart';
import 'package:poll_app/views/home_view.dart';

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

  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeView(),
        '/createPoll': (_) => const CreatePollView(),
        '/addQuestion': (_) => const AddQuestionView()
      },
    );
  }
}
