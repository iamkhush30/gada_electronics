import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Product_Details.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/products/Heart_Button.dart';
import 'package:gadaelectronics_user/models/Product_Model.dart';
import 'package:provider/provider.dart';

import '../../Const/App_const.dart';
import '../../Providers/whishlist_provider.dart';
import '../subtitle_text.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productModel = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: GestureDetector(
        onTap: () async{
          productProvider.addViewedRecentlyProduct(productId: productModel.productId,);
          await Navigator.of(context).pushNamed(ProductDetailsScreen.routName,arguments: productModel.productId);
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 2,
          color: Colors.white,
            child: Container(
              width: size.width * 0.38,
              height: size.width * 0.60,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4,),
                    Flexible(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          alignment: Alignment.center,
                          child: Image.network(fit: BoxFit.fill,
                              productModel.productImage
                          )
                        )
                        // FancyShimmerImage(
                        //     imageUrl: AppConst.iphone,
                        //     height: size.width * 0.35,
                        //     width: size.width * 0.35,
                        // ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2,),
                          SizedBox(
                            child: Flexible(
                              child: Text(
                                productModel.productTitle,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          FittedBox(
                            child: SubtitleTextWidget(
                              label: "₹${productModel.productPrice}",
                              fontsize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0,right: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeartButton(bkgColor: Colors.blue.shade900, productId: productModel.productId,),
                                IconButton(
                                    onPressed: () async{
                                      if(cartProvider.isProdinCart(productId: productModel.productId))
                                      {
                                        Fluttertoast.showToast(msg: "Product Already in cart");
                                        return ;
                                      }
                                      try{
                                        await cartProvider.addtoCart(productId: productModel.productId, qty: 1, context: context);
                                      } catch(error){
                                        MyAppFunction.showErrororWarnig(
                                            context: context,
                                            subTitel: error.toString(),
                                            fct: (){}
                                        );
                                      }
                                      // if(cartProvider.isProdinCart(productId: productModel.productId))
                                      // {
                                      //   return ;
                                      // }
                                      // cartProvider.addProductToCart(productId: productModel.productId);
                                    },
                                    icon: Icon(cartProvider.isProdinCart(productId: productModel.productId)?Icons.check:
                                    Icons.add_shopping_cart_outlined,size: 25,color: Colors.blue.shade900,)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
