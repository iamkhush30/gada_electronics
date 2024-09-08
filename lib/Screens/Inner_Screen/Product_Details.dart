import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/App_Name_Text.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Widgets/products/Heart_Button.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';


class ProductDetailsScreen extends StatefulWidget {

  static const routName="/ProductDetailsScreen";
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider=Provider.of<CartProvider>(context);
    String? productId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrentProduct = productProvider.findByProductId(productId!);
    return Scaffold(
      appBar: AppBar(title: AppNameText(fontSize: 25,),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset("${AssetManager.imgPath}/G1.png"),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: getCurrentProduct == null ? SizedBox.shrink() : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(getCurrentProduct!.productImage,
                     width: double.infinity,
                     height: size.height*0.45,),
                // FancyShimmerImage(
                //   imageUrl: getCurrentProduct!.productImage,
                //   width: double.infinity,
                //   height: size.height*0.45,
                // )
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left:10.0,right: 10.0),
                    child: SelectableText(
                      getCurrentProduct!.productTitle,
                      maxLines: 4,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0,),
                  child: SelectableText(
                    "₹${getCurrentProduct!.productPrice}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                HeartButton(bkgColor: Colors.blue.shade900,productId: getCurrentProduct.productId,),

                SizedBox(width: 10,),
                SizedBox(
                  height: kBottomNavigationBarHeight-10,
                  child: ElevatedButton.icon(
                    onPressed: ()async{
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
                    icon: Icon(cartProvider.isProdinCart(productId: getCurrentProduct.productId)?Ionicons.cart:Ionicons.cart_outline,color: Colors.white),
                    label: Text(cartProvider.isProdinCart(productId: getCurrentProduct.productId)?"Added to Cart":"Add to Cart",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade900,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),

            Align(
              alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TitleTextWidget(label: "About this product"),
                      SubtitleTextWidget(label: "in ${getCurrentProduct!.productCategory}")
                    ],
                  ),
                )
            ),

            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Text(getCurrentProduct!.productDescription,
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }
}
