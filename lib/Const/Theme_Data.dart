import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Const/Appcolors.dart';

class Styles {
  static ThemeData themeData({required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme
            ? Appcolors.darkScaffoldColor
            : Appcolors.lightScaffoldColor,
        cardColor: isDarkTheme
            ? const Color.fromARGB(255, 13, 6, 37)
            : Appcolors.lightCardColor,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }
}

