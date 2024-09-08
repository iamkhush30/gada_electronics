import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Screens/Cart/Cart_Widget.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Widgets/products/product_widget.dart';
import 'package:provider/provider.dart';
import '../../Services/Asset_Manager.dart';
import '../../Widgets/App_Name_Text.dart';
import '../../Widgets/Empty_Bag.dart';

class ViewedRecently extends StatelessWidget {
  static const routName="/ViewedRecently";
  const ViewedRecently({super.key});

  final bool isEmpty = false;



  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return productProvider.viewedRecentlyProducts.isEmpty? Scaffold(
      appBar: AppBar(title: AppNameText(fontSize: 25,),backgroundColor: Colors.transparent,),
      body: EmptyBag(
        imgPath: '${AssetManager.imgPath}/Empty Viewed Recently.png',
        title: 'Your Viewed List is Empty',
        subTitle: 'It seems your browsing history is clear. Why not explore our collection and find something new?',
        buttonText: 'Explore Now',
      ),
    ):
    Scaffold(
        appBar: AppBar(
          title: AppNameText(fontSize: 25,),

          actions: [
            IconButton(
              onPressed: (){MyAppFunction.showErrororWarnig(
                context: context,
                subTitel: "Are you sure you want to empty your browsing history?",
                fct: (){
                  productProvider.clearLocalviewedRecentlylist();
                },
                isError: false
              );},
              icon:Icon(Icons.delete)
            ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0,bottom: 10),
                  child: Container(
                    height:MediaQuery.of(context).size.height*1,
                    child: DynamicHeightGridView(
                        mainAxisSpacing:12,crossAxisSpacing:12,
                        builder: (context,index){
                          return ChangeNotifierProvider.value(
                              value: productProvider.viewedRecentlyProducts[index],
                              child: ProductWidget(productId: productProvider.viewedRecentlyProducts[index].productId));
                        }, itemCount: productProvider.viewedRecentlyProducts.length, crossAxisCount: 2
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}