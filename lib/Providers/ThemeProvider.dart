import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;

  // For Dark Theme

  ThemeProvider() {
    getTheme();
  }

  setDarkTheme({required bool themevalue}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(THEME_STATUS, themevalue);
    _darkTheme = themevalue;
    notifyListeners();
  }

  // For get Theme using Button

  Future<bool> getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkTheme = pref.getBool(THEME_STATUS) ?? false;
    notifyListeners();
    return _darkTheme;
  }
}
