import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color orange = const Color(0xfff19c79);
Color green = const Color(0xff9fc490);

class AppThemes {
  ThemeData themeData = ThemeData(
    //COLORS
    colorScheme: ColorScheme.light(
      primary: Color(0xff72479d),
      secondary: orange,
      background: Color(0xfff1ffe7),
      onPrimary: Color(0xfff1ffe7),
      onSecondary: Color(0xff0d0106),
      onBackground: Color(0xff0d0106),
      primaryContainer: Color(0xfff19c79),
      secondaryContainer: green,
      //TODO fill necessary colors
    ),

    //TEXT
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: const TextTheme(
      headline3: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),

      //TODO fill text themes
    ),

    //TEXT FIELD
    inputDecorationTheme: const InputDecorationTheme(
        //TODO fill input decoration themes
        ),

    //BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 30)),
      ),
    ),
    //TODO fill button themes
    outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
            //TODO fill button themes
            )),
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
            //TODO fill button themes
            )),

    //OTHER
    //TODO fill other themes
  );
}
