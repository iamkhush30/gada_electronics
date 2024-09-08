import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Address/Address_Screen.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:provider/provider.dart';

class BottomCheckOut extends StatelessWidget {
  const BottomCheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    return Container(
      child: SizedBox(
        height: kBottomNavigationBarHeight+20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total ${cartProvider.getCartItems.length} Product /${cartProvider.getQty()} items",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                SubtitleTextWidget(label: "₹${cartProvider.getTotal(productProvider: productProvider)}0",color: Colors.blue,),
              ],
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                onPressed: ()async{
                  await addressProvider.fetchAddress();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen(),));
                },
                child: Text("Check Out"),style: ButtonStyle(elevation: MaterialStatePropertyAll(2)),
              ),
            )
          ],
        ),
      )
    );
  }
}
