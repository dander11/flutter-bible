import 'package:flutter/material.dart';

class Designs {
  static ThemeData darkTheme = getDarkTheme();

  static TextTheme darkTextTheme =
      TextTheme(bodyText2: TextStyle(color: Colors.white70, fontSize: 18.0));

  static ThemeData defaultTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey.shade100,
  );

  static ThemeData getDarkTheme() {
    ThemeData darkTheme = ThemeData.dark();
    return darkTheme.copyWith(
      textSelectionColor: Colors.blueAccent.shade200,
      textSelectionHandleColor: Colors.white,
      textTheme: darkTheme.textTheme.copyWith(
        bodyText2: darkTheme.textTheme.bodyText2.copyWith(
          color: Colors.white70,
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
        subtitle1: darkTheme.textTheme.subtitle1.copyWith(
          color: Colors.white70,
          fontSize: 22.0,
        ),
        headline6: darkTheme.textTheme.headline6.copyWith(
          color: darkTheme.primaryColor,
        ),
      ),
      iconTheme: darkTheme.iconTheme.copyWith(color: Colors.white70),
      buttonColor: Colors.blue.shade900,
      accentColor: Colors.blue.shade900,
    );
  }
}
