import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Screens/Cart/Cart_Widget.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Widgets/products/product_widget.dart';
import 'package:provider/provider.dart';
import '../../Services/Asset_Manager.dart';
import '../../Widgets/App_Name_Text.dart';
import '../../Widgets/Empty_Bag.dart';

class WishlistScreen extends StatelessWidget {
  static const routName="/WishlistScreen";
  const WishlistScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishLists.isEmpty ? Scaffold(
      appBar: AppBar(title: AppNameText(fontSize: 25,),backgroundColor: Colors.transparent,),
      body: EmptyBag(
        imgPath: 'assets/images/empty_wishlist.png',
        title: 'Your Wishlist is Empty',
        subTitle: 'Your wishlist is waiting for treasures. Explore our products and add items to create your dream wishlist!',
        buttonText: 'Start Adding',),
    ):
    Scaffold(
        appBar: AppBar(
          title: AppNameText(fontSize: 25,),
          actions: [
            IconButton(onPressed: (){
              MyAppFunction.showErrororWarnig(
                context: context,
                subTitel: "Are you sure you want to empty Wishlist?",
                fct: ()async{
                  wishlistProvider.clearLocalWishList();
                  await wishlistProvider.clearWhishlistfromFirebase();
                },
                isError: false
              );
            }, icon:Icon(Icons.delete)),
          ],
          leading:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("${AssetManager.imgPath}/G1.png"),),

          backgroundColor: Colors.transparent,
        ),

        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height:MediaQuery.of(context).size.height,
                  child: DynamicHeightGridView(
                    mainAxisSpacing:12,
                    crossAxisSpacing:12,
                    itemCount: wishlistProvider.getWishLists.length,
                    crossAxisCount: 2,
                      builder: (context,index){
                        return ProductWidget(productId: wishlistProvider.getWishLists.values.toList()[index].productId,);
                      },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}