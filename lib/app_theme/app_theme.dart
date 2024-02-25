import 'package:flutter/material.dart';


class AppTheme {
  static const Color primary = Color.fromARGB(255, 0, 0, 0);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //primaryColor: Color.fromARGB(255, 20, 40, 56),
    primaryColor: Color.fromARGB(255, 20, 40, 56),

    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50))
      ),
    )
  );
}
