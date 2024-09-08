import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Const/Appcolors.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Providers/ThemeProvider.dart';
import 'package:gadaelectronics_user/Widgets/products/cat_rounded_widget.dart';
import 'package:gadaelectronics_user/Widgets/products/latest_arrival.dart';
import 'package:provider/provider.dart';

import '../Services/Asset_Manager.dart';
import '../Widgets/App_Name_Text.dart';
import '../Widgets/Subtitle_text.dart';
import '../Widgets/Title_Text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routName="/HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);
      return Scaffold(
        appBar: AppBar(
          title: AppNameText(fontSize: 25,),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("${AssetManager.imgPath}/G1.png"),),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(
                  height: size.height * 0.22,
                  child: SizedBox(height: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: Swiper(autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.asset(
                              AppConst.bannersImage[index], fit: BoxFit.fill,);
                            //Image.network(AppConst.bannersImage[0],fit: BoxFit.fill,);
                          },
                          itemCount: 4,
                          pagination: SwiperPagination(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Visibility(visible: productProvider.getProducts.isNotEmpty,child: TitleTextWidget(label: "Latest Arrival")),
                ),
                SizedBox(height: 10.0,),
                Visibility(
                  visible: productProvider.getProducts.isNotEmpty,
                  child: SizedBox(
                    height: size.height * 0.35,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.5, right: 2.5),
                      child: ListView.builder(
                          itemCount: productProvider.getProducts.length<10 ? productProvider.getProducts.length : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider.value(
                                value: productProvider.getProducts[index],
                                child: const LatestArrivalProductsWidget()
                            );
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TitleTextWidget(label: "Categories"),
                ),
                SizedBox(height: 15,),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  children:
                  List.generate(AppConst.categoriesList.length, (index) {
                    return CategoryRoundedWidget(
                      image: AppConst.categoriesList[index].image,
                      name: AppConst.categoriesList[index].name,);
                  }),
                ),
              ],),
          ),
        ),
      );
    }
}
