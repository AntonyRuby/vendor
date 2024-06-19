import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xFFff0092),
  secondaryHeaderColor: Color(0xFFff0092),
  disabledColor: Color(0xFF6f7275),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cardColor: Colors.black,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Color(0xFFff0092))),
  colorScheme:
      ColorScheme.dark(primary: Color(0xFFff0092), secondary: Color(0xFFff0092))
          .copyWith(error: Color(0xFFff0092)),
);
