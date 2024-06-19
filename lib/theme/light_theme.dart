import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: Color(0xFFff0092),
  secondaryHeaderColor: Color(0xFFff0092),
  disabledColor: Color(0xFFA0A4A8),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Color(0xFFff0092))),
  colorScheme: ColorScheme.light(
          primary: Color(0xFFff0092), secondary: Color(0xFFff0092))
      .copyWith(error: Color(0xFFff0092)),
);
