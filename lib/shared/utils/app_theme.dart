import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.white,
      primary: primaryColor,
      secondary: Colors.blue.shade200,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.deepPurple,
      secondary: Colors.grey.shade500,
    ));
