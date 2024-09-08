import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Screens/Cart/Cart_Screen.dart';
import 'package:gadaelectronics_user/Screens/HomeScreen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/View_Recently.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Wishlist.dart';
import 'package:gadaelectronics_user/Screens/Profile_Screen.dart';
import 'package:gadaelectronics_user/Screens/Search_Screen.dart';
import 'package:gadaelectronics_user/Screens/Splash_Screen.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  static const routName='/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late List<Widget> screen;
  int currentScreen=0;
  late PageController controller;
  num items=0;
  bool isLoadingProd = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screen = const [
      //SplashScreen(),
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
    ViewedRecently(),
    WishlistScreen()
    ];

    controller=PageController(initialPage: currentScreen);
  }

  Future<void> fetchfct()async{
    final productsProvider = Provider.of<ProductProvider>(context,listen: false);
    final cartProvider = Provider.of<CartProvider>(context,listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context,listen: false);
    await wishlistProvider.fetchWishlist();

    try{
      if(currentScreen != 1){
        await productsProvider.fetchProducts();
      }
      await cartProvider.fetchCart();
    } catch(error){
      print(error);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isLoadingProd){
      fetchfct();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () async{ return false; },
      child: Scaffold(
        body: PageView(
          controller:controller ,
          children:screen,
          physics: const NeverScrollableScrollPhysics(),
        ),


        bottomNavigationBar: NavigationBar(
          selectedIndex: currentScreen,
          elevation: 10,
          backgroundColor:Theme.of(context).scaffoldBackgroundColor ,
          height: kBottomNavigationBarHeight,
          onDestinationSelected: (index){
            setState(() {
              currentScreen=index;
            });
            controller.jumpToPage(currentScreen);
          },
          destinations:  [
            NavigationDestination(selectedIcon: Icon(IconlyBold.home), icon: Icon(IconlyLight.home), label: "Home"),
            NavigationDestination(selectedIcon: Icon(IconlyBold.search), icon: Icon(IconlyLight.search), label: "Search"),
            NavigationDestination(selectedIcon: Badge(label : Text(cartProvider.getCartItems.length.toString()), backgroundColor: Colors.blue, child: Icon(IconlyBold.bag)), icon: Badge(label : Text(cartProvider.getCartItems.length.toString()), backgroundColor: Colors.blue, child: Icon(IconlyLight.bag)), label: "Cart"),
            NavigationDestination(selectedIcon: Icon(IconlyBold.profile), icon: Icon(IconlyLight.profile), label: "Profile"),

      ]),
      ),
    );
  }
}

