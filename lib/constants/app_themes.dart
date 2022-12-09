import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color orange = const Color(0xfff19c79);
Color green = const Color(0xff9fc490);
Color purple = const Color(0xff72479d);
Color white = const Color(0xfff1ffe7);
Color black = const Color(0xff0d0106);

ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
  primary: const Color(0xff72479d), //purple
  secondary: const Color(0xfff19c79), //orange
  tertiary: const Color(0xff9fc490), //dark green
  onTertiary: const Color(0xfff1ffe7), //light green
  background: Colors.white,
  onBackground: Colors.black,
));

ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
  primary: const Color(0xff72479d), //purple
  secondary: const Color(0xfff19c79), //orange
  tertiary: const Color(0xff9fc490), //dark green
  onTertiary: const Color(0xfff1ffe7), //light green
  background: Colors.black,
  onBackground: Colors.white,
));

class AppThemes {
  ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.light(
    primary: const Color(0xff72479d), //purple
    onPrimary: Colors.white,
    secondary: const Color(0xfff19c79), //orange
    onSecondary: Colors.black,
    tertiary: const Color(0xff9fc490), //dark green
    onTertiary: const Color(0xfff1ffe7), //light green
    background: Colors.white,
    onBackground: Colors.black,
  ));

  ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.dark(
    primary: const Color(0xff72479d), //purple
    onPrimary: Colors.white,
    secondary: const Color(0xfff19c79), //orange
    onSecondary: Colors.black,
    tertiary: const Color(0xff9fc490), //dark green
    onTertiary: const Color(0xfff1ffe7), //light green
    background: Colors.black,
    onBackground: Colors.white,
  ));

  ThemeData themeData = ThemeData(
    //COLOR
    colorScheme: ColorScheme.light(
      primary: purple,
      onPrimary: white,
      secondary: orange,
      onSecondary: black,
      tertiary: green,
      onTertiary: black,
      background: white,
      onBackground: black,
    ),

    //TEXT
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      headline2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: white,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      headline4: TextStyle(
        fontSize: 24,
        color: purple,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        color: black,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        color: black,
      ),
      caption: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: purple,
      ),
    ),

    //TEXT FIELD
    inputDecorationTheme: const InputDecorationTheme(
      counterStyle: TextStyle(fontSize: 16),
    ),

    //BUTTONS

    //OTHER
  );
}
