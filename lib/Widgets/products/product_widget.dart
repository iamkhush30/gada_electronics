import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Product_Details.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/models/Product_Model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({super.key,required this.productId});
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    //final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProductId(widget.productId);
    final cartProvider=Provider.of<CartProvider>(context,listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final getWishlistId = wishlistProvider.findWishlistIdByProductId(getCurrentProduct!.productId);
        Size size=MediaQuery.of(context).size;
    return getCurrentProduct == null ? SizedBox.shrink():Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async{
              setState(() {
                productProvider.addViewedRecentlyProduct(productId: getCurrentProduct!.productId,);
              });
              await Navigator.of(context).pushNamed(ProductDetailsScreen.routName,arguments: getCurrentProduct.productId);
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(image: NetworkImage(getCurrentProduct!.productImage),width: double.infinity,height: size.height*0.22,))
            ),
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.only(top: 2.0,bottom: 5.0),
            child: TitleTextWidget(label: getCurrentProduct!.productTitle,maxLines: 2,fontsize: 16,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0,right: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SubtitleTextWidget(
                    label: "₹${getCurrentProduct!.productPrice}",
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontsize: 14.7
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: ()async{

                        if(wishlistProvider.isProdinWishList(productId: getCurrentProduct.productId))
                        {
                          await wishlistProvider.removeWhishlistfromFirebase(whishlistId: getWishlistId!.wishlistId, productId: getCurrentProduct.productId);
                          return ;
                        }
                        try{
                          await wishlistProvider.addtowhishlist(productId: widget.productId,context: context);
                        } catch(error){
                          MyAppFunction.showErrororWarnig(
                              context: context,
                              subTitel: error.toString(),
                              fct: (){}
                          );
                        }
                      },
                      icon: Icon(
                        wishlistProvider.isProdinWishList(productId: widget.productId)? IconlyBold.heart : IconlyLight.heart,
                        size: 25,
                        color: wishlistProvider.isProdinWishList(productId: widget.productId)?Colors.red:null,
                      ),
                      style: IconButton.styleFrom(
                        elevation: 10,
                      ),
                    ),
                    InkWell(
                      onTap:()async{
                        if(cartProvider.isProdinCart(productId: getCurrentProduct.productId))
                        {
                          Fluttertoast.showToast(msg: "Product Already in cart");
                          return ;
                        }
                        try{
                          await cartProvider.addtoCart(productId: getCurrentProduct.productId, qty: 1, context: context);
                        } catch(error){
                          MyAppFunction.showErrororWarnig(
                              context: context,
                              subTitel: error.toString(),
                              fct: (){}
                          );
                        }
                      },
                      child: Icon(
                          cartProvider.isProdinCart(productId: getCurrentProduct.productId)?Icons.check:
                          Icons.add_shopping_cart_outlined,size: 25,),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 12.0,)
        ],
      ),
    );
  }
}
