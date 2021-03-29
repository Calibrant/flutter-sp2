import 'package:flutter/material.dart';

final kDarkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.brown,
  ),
);

final kLightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.lightBlue[900],
  appBarTheme: AppBarTheme(
    color: Colors.blue,
  ),
);
