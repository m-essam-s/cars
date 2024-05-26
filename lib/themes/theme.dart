import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  hintColor: Colors.amber,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    titleMedium: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
    titleSmall: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
    headlineLarge: TextStyle(fontSize: 24.0, fontFamily: 'Hind'),
    headlineMedium: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
    headlineSmall: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
    bodyLarge: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
    bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    bodySmall: TextStyle(fontSize: 12.0, fontFamily: 'Hind'),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  hintColor: Colors.amber,
);
