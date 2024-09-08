import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Screens/Cart/Cart_Widget.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:provider/provider.dart';
import '../../Providers/Products_Providers.dart';
import '../../Services/Asset_Manager.dart';
import '../../Widgets/App_Name_Text.dart';
import '../../Widgets/Empty_Bag.dart';
import 'Bottom_Check_Out.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static int cartItemCount = 15;
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    //final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return ThemeProvider();
          })
        ],
      child: cartProvider.getCartItems.isEmpty? Scaffold(
        appBar: AppBar(
          title: AppNameText(fontSize: 25,),
          backgroundColor: Colors.transparent,
          leading:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("${AssetManager.imgPath}/G1.png"),
          ),
        ),
        body: EmptyBag(
          imgPath: '${AssetManager.imgPath}/T1.png',
          title: 'Your Cart Is Empty',
          subTitle: 'Looks Like Your Cart Is Empty add \n something And Make me Happy',
          buttonText: 'Shop Now',
        ),

      ):
      Scaffold(
          bottomSheet: const BottomCheckOut(),
          appBar: AppBar(
            title: TitleTextWidget(label: "Cart(${cartProvider.getCartItems.length})",),
            actions: [
              IconButton(onPressed: (){
                MyAppFunction.showErrororWarnig(
                  isError: false,
                  context: context,
                  subTitel: 'Clear Cart?',
                  fct: (){
                    cartProvider.clearCartfromFirebase();
                    //cartProvider.clearLocalCart();
                  }

                );

              }, icon:const Icon(Icons.delete)),
            ],
            leading:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset("${AssetManager.imgPath}/G1.png"),),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),

          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height:MediaQuery.of(context).size.height-225,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(itemCount:cartProvider.getCartItems.length, itemBuilder:(context,index) {
                            return ChangeNotifierProvider.value(
                              child: CartWidget(),
                              value: cartProvider.getCartItems.values.toList()[index],
                            );
                          } )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}