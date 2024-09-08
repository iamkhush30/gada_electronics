import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/Auth/Login.dart';
import 'package:provider/provider.dart';

import '../Const/Theme_Data.dart';
import 'HomeScreen.dart';


class SplashScreen extends StatelessWidget {
  static const routName = '/SplashScreen';
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            debugShowCheckedModeBanner: false,
            home:Scaffold(
              body: AnimatedSplashScreen(
                splash: Center(
                  child: Container(
                    color: Colors.white,
                    child: Image.asset('assets/images/splash.jpg',height: 100,),
                  ),
                ),
                splashIconSize: 250,
                duration: 1500,
                splashTransition: SplashTransition.fadeTransition,
                //nextScreen: Login(),
                nextScreen: RootScreen(),
              ),
            )
          );
        },
    );
  }
}
