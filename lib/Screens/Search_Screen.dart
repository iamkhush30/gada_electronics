import 'dart:math';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Widgets/App_Name_Text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/Widgets/products/product_widget.dart';
import 'package:gadaelectronics_user/models/Product_Model.dart';
import '../../Services/Asset_Manager.dart';
import 'package:provider/provider.dart';
import '../Providers/ThemeProvider.dart';

class SearchScreen extends StatefulWidget {
  static const routName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController search;
  bool showDelete = false;
  @override
  void initState() {
    search = TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    search.dispose();
    super.dispose();
  }
  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context).getIsDarkTheme ? Colors.white : Color.fromARGB(255, 9, 3, 27);
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory==null? productProvider.products : productProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppNameText(fontSize: 25,),
          leading:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("${AssetManager.imgPath}/G1.png"),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: productList.isEmpty ? Center(child: TitleTextWidget(label: "No Product Found"))
          : StreamBuilder<List<ProductModel>>(
            stream: productProvider.fetchProductsStream(),
            builder: (context, snapshot) {
              return Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,),
                        hintText: "Search Item...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: themeProvider
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              FocusScope.of(context).unfocus();
                              search.clear();
                            });
                          },
                         child: Icon(Icons.clear,color: showDelete ? Colors.red : Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ),
                      onTap: (){
                        setState(() {showDelete = true;});
                      },
                      onTapOutside:  (event) {
                        setState(() {showDelete = false;});
                      },
                      onChanged: (value){
                        setState(() {
                          productListSearch = productProvider.searchQuery(searchText: search.text,passedList: productList);
                        });
                      },
                      onSubmitted: (value){
                        setState(() {
                          productListSearch = productProvider.searchQuery(searchText: search.text,passedList: productList);
                        });
                      },
                      controller:search ,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if(search.text.isNotEmpty && productListSearch.isEmpty)...[
                    Center(child: TitleTextWidget(label: "No Product Found")),
                  ],
                  Expanded(
                    child: DynamicHeightGridView(
                      mainAxisSpacing:12,
                      crossAxisSpacing:12,
                      itemCount: search.text.isNotEmpty ? productListSearch.length : productList.length,
                      crossAxisCount: 2,
                      builder: (context,index){
                        return ProductWidget(productId: search.text.isNotEmpty ? productListSearch[index].productId : productList[index].productId);
                      },
                    ),
                  )
                ],
              ),
                      );
            }
          ),
      ),
    );
  }
}
