import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Providers/user_provider.dart';
import 'package:gadaelectronics_user/Providers/whishlist_provider.dart';
import 'package:gadaelectronics_user/Screens/Auth/Login.dart';
import 'package:gadaelectronics_user/Screens/Auth/Register.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Profile Address/Address_Screen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/Order_Screen.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/View_Recently.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Wishlist.dart';
import 'package:gadaelectronics_user/Screens/loading_manager.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/models/user_model.dart';
import 'package:provider/provider.dart';
import '../Providers/ThemeProvider.dart';
import '../Services/Asset_Manager.dart';
import '../Widgets/App_Name_Text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo()async{
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    final orderProvider = Provider.of<OrderProvider>(context,listen: false);
    try{
      setState(() {
        _isLoading = true;
      });
      await orderProvider.removeUserProduct();
      await orderProvider.fetchOrder();
      userModel = await userProvider.fetchUserInfo();
    }
    catch(e){
      await MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: e.toString(),
          fct: (){}
      );
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState(){
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
        appBar: AppBar(title: AppNameText(fontSize: 25,),

          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("${AssetManager.imgPath}/G1.png"),),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),

        body: LoadingManager(
          isLoading: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false ,
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: TitleTextWidget(label: "Please Login First"),
                  ),
                ),
                userModel==null? const SizedBox.shrink() :
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20),
                  child: Row( //This Row For Profile Picture & Profile Name :
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).colorScheme.background, width: 3),
                          image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(userModel!.userImage)),
                        ),
                      ),

                      SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          TitleTextWidget(label: userModel!.userName),
                          SubtitleTextWidget(label: userModel!.userEmail),
                        ],
                      )
                    ],
                  ),
                ),


                //SizedBox(height: 15,),


                Padding( // For Profile
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, indent: 10, endIndent: 10,),
                      SizedBox(height: 15,),
                      TitleTextWidget(label: "General"),
                      SizedBox(height: 15,),
                      Visibility(
                        visible: userModel==null ? false : true ,
                        child: CustomListTile(imgPath: '${AssetManager.imgPath}/O1.png',
                          text: 'All Order',
                          function: () async{
                            await orderProvider.removeUserProduct();
                            await orderProvider.fetchOrder();
                            Navigator.of(context).pushNamed(OrderScreen.routName);
                          },),
                      ),
                      SizedBox(height: 15,),
                      Visibility(
                        visible: userModel==null ? false : true ,
                        child: CustomListTile(imgPath: "assets/images/wishlist.png",
                          text: 'Wistlist',
                          function: () async {
                            await Navigator.of(context).pushNamed(WishlistScreen.routName);
                          },),
                      ),
                      const SizedBox(height: 15,),
                      CustomListTile(
                        imgPath: '${AssetManager.imgPath}/Viewed Recently.png',
                        text: 'Viewed Recently',
                        function: () async {
                          await Navigator.of(context).pushNamed(ViewedRecently.routName);
                        },),
                      const SizedBox(height: 15,),
                      CustomListTile(imgPath: '${AssetManager.imgPath}/A1.png',
                        text: 'Address',
                        function: () async{
                          await addressProvider.fetchAddress();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen(),));
                        },),
                      const SizedBox(height: 20,),
                      const Divider(thickness: 1, indent: 10, endIndent: 10,),
                      const SizedBox(height: 15,),
                      const TitleTextWidget(label: "Settings"),
                      const SizedBox(height: 10,),

                      SwitchListTile(
                          title: Text(
                              themeProvider.getIsDarkTheme
                                  ? "Dark Mode"
                                  : "Light Mode"),
                          value: themeProvider.getIsDarkTheme,
                          secondary: Image.network(themeProvider.getIsDarkTheme
                              ? 'https://cdn-icons-png.flaticon.com/128/547/547433.png'
                              :
                          'https://cdn-icons-png.flaticon.com/128/10484/10484062.png',
                            height: 45,),
                          inactiveThumbImage: const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/128/547/547433.png'),
                          activeThumbImage: const NetworkImage(
                              'https://cdn-icons-png.flaticon.com/128/10484/10484062.png'),
                          onChanged: (value) {
                            themeProvider.setDarkTheme(themevalue: value);
                          }),
                    ],
                  ),
                ),


                Center(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            user==null ? Navigator.pushNamed(context, Login.routName) :
                            MyAppFunction.showErrororWarnig(
                                context: context,
                                subTitel: "Are You Sure? You want to Logout",
                                fct: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Fluttertoast.showToast(msg: "Successfully Logout");
                                  Navigator.pushNamed(context, Login.routName);
                                },
                                isError: false
                            );
                          },
                          icon: Icon(user==null?IconlyBold.login:IconlyBold.logout, color: Colors.red,),
                          label: Text(user==null ? "Login" : "Logout")),
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}


// This Class For Profile Categories :
class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.imgPath, required this.text, required this.function});

  final String imgPath,text;
  final Function function;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:(){
        function();
      },
      title: SubtitleTextWidget(label: text,),
      leading: Image.asset(imgPath,height: 45,),
      trailing: Icon(IconlyLight.arrowRight2),
    );
  }
}

