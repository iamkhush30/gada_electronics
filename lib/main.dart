import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Const/Theme_Data.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Providers/user_provider.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/Auth/Forgot_Password.dart';
import 'package:gadaelectronics_user/Screens/Auth/Login.dart';
import 'package:gadaelectronics_user/Screens/Auth/Register.dart';
import 'package:gadaelectronics_user/Screens/HomeScreen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/Order_Screen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Product_Details.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/View_Recently.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Wishlist.dart';
import 'package:gadaelectronics_user/Screens/Search_Screen.dart';
import 'package:gadaelectronics_user/Screens/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp (
        options: FirebaseOptions(
          apiKey: 'AIzaSyAZhKhpwpCKgO-8vosX1yOhW-IUkaDd0fM',
          appId: '1:827421952722:android:ea31fd0396195b75567b0b',
          messagingSenderId: '827421952722',
          projectId: 'gada-electronics-cf23f',
          authDomain: 'xxxxxxxxxxxxxxxxxxx',
          databaseURL: 'xxxxxxxxxxxxxxxxxxx',
          storageBucket: 'gs://gada-electronics-cf23f.appspot.com',
          measurementId: 'xxxxxxxxxxxxxxxxxxx',
        )
      ),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        else if(snapshot.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: SelectableText(snapshot.error.toString()),
              ),
            ),
          );
        }
        final _auth = FirebaseAuth.instance.currentUser;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {return ThemeProvider();}),
            ChangeNotifierProvider(create: (_) {return ProductProvider();}),
            ChangeNotifierProvider(create: (_) {return CartProvider();}),
            ChangeNotifierProvider(create: (_) {return WishlistProvider();}),
            ChangeNotifierProvider(create: (_) {return UserProvider();}),
            ChangeNotifierProvider(create: (_) {return AddressProvider();}),
            ChangeNotifierProvider(create: (_) {return OrderProvider();}),

          ],
          builder: (context,child){
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme, context: context),
              debugShowCheckedModeBanner: false,
              //home: SplashScreen(),
              home: _auth==null ? const Login() : const RootScreen(),
              //home: RegisterScreen(),
              //home: RootScreen(),
              routes: {
                RootScreen.routName:(context)=>const RootScreen(),
                HomeScreen.routName:(context)=>const HomeScreen(),
                SplashScreen.routName:(context) => const SplashScreen(),
                ProductDetailsScreen.routName:(context)=>const ProductDetailsScreen(),
                WishlistScreen.routName: (context)=>const WishlistScreen(),
                ViewedRecently.routName: (context)=>const ViewedRecently(),
                Login.routName:(context)=>const Login(),
                RegisterScreen.routName:(context)=>const RegisterScreen(),
                OrderScreen.routName:(context) => const OrderScreen(),
                ForgotPasswordScreen.routName:(context) => const ForgotPasswordScreen(),
                SearchScreen.routName:(context) => const SearchScreen(),
              },
            );
          },
        );
      },
    );
  }
}

//gadaelectronics@gmail.com
//gada#123