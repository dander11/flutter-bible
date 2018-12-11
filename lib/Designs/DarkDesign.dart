import 'package:flutter/material.dart';

class Designs {
  static ThemeData darkTheme = getDarkTheme();

  static TextTheme darkTextTheme = new TextTheme(
      body2: new TextStyle(color: Colors.white70, fontSize: 18.0));

  static ThemeData defaultTheme = new ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey.shade100,
  );

  static ThemeData getDarkTheme() {
    ThemeData darkTheme = new ThemeData.dark();
    return darkTheme.copyWith(
      textTheme: darkTheme.textTheme.copyWith(
        body2: darkTheme.textTheme.body2
            .copyWith(color: Colors.white70, fontSize: 18.0),
        display1: darkTheme.textTheme.display1
            .copyWith(color: Colors.white70, fontSize: 22.0),
        title: darkTheme.textTheme.title.copyWith(
          color: darkTheme.primaryColor,
        ),
      ),
      iconTheme: darkTheme.iconTheme.copyWith(color: Colors.white70),
      buttonColor: Colors.blue.shade900,
      accentColor: Colors.blue.shade900,
    );
  }
}
