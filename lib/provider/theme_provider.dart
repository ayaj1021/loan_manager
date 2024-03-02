import 'package:flutter/material.dart';
import 'package:loan_manager/database/theme_db.dart';

class ThemeProvider with ChangeNotifier {
  ThemePrefs themePrefs = ThemePrefs();
  bool _darkTheme = false;

  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    themePrefs.setDarkTheme(value);
    notifyListeners();
  }

  // ThemeData _themeData = lightMode;

  // ThemeData get themeData => _themeData;

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }

  // void toggleTheme() async {
  //   //  await pref.setString('themeData', themeData);

  //   if (_themeData == lightMode) {
  //     themeData = darkMode;
  //   } else {
  //     themeData = lightMode;
  //   }
  // }
}
