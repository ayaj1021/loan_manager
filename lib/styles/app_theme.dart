import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkTheme ? Colors.black : whiteColor,
        primaryColor: primaryColor,
        colorScheme: isDarkTheme
            ? ColorScheme.dark(
                background: Colors.black,
                primary: Colors.deepPurple,
                secondary: Colors.grey.shade500,
              )
            : ColorScheme.light(
                background: Colors.white,
                primary: primaryColor,
                secondary: Colors.blue.shade200,
              ),
        // primaryTextTheme: TextTheme(  isDarkTheme ? whiteColor : Colors.black),
        bottomAppBarTheme:
            BottomAppBarTheme(color: isDarkTheme ? Colors.black : whiteColor)
        // buttonTheme: Theme.of(context)
        //     .buttonTheme
        //     .copyWith(colorScheme: primaryColor as ColorScheme),
        );
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: primaryColor,
    secondary: Colors.blue.shade200,
  ),
);

// ThemeData darkMode = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: ColorScheme.dark(
//       background: Colors.black,
//       primary: Colors.deepPurple,
//       secondary: Colors.grey.shade500,
//     ),
//     );
