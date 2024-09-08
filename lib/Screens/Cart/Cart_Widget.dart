import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Screens/Cart/Qty_Counter.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Widgets/products/Heart_Button.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:provider/provider.dart';

import 'Qty_Bottom_Sheet.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool fav = false;
    int count = 1 ;
    Size size=MediaQuery.of(context).size;
    final cartModel = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrProduct = productProvider.findByProductId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);

    return getCurrProduct==null ? SizedBox.shrink() : FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:BorderRadius.circular(12.0) ,
                child: Image.network(
                  getCurrProduct.productImage,
                  height: size.height*0.2,
                  width: size.height*0.2,
                ),
              ),
              SizedBox(width: 10,),
              SingleChildScrollView(
                child: IntrinsicWidth(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      SizedBox(
                          width:size.width*0.6 ,
                          child: TitleTextWidget(label: getCurrProduct.productTitle,maxLines: 2,fontsize: 19,)
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                              child: TitleTextWidget(label: "₹${getCurrProduct.productPrice}",fontsize: 16,color: Colors.blue,)
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          HeartButton(bkgColor: Colors.blue.shade900,productId: getCurrProduct.productId),
                          IconButton(onPressed: ()async{
                            cartProvider.removeCartfromFirebase(
                                cartId: cartModel.cartId,
                                productId: getCurrProduct.productId,
                                qty: cartModel.quantity!);
                          } ,icon: Icon(IconlyLight.delete)),
                          SizedBox(width: 30),
                          Align(
                              alignment: Alignment.centerRight,
                              child: QtyCounter(cartModel: cartModel,)
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



