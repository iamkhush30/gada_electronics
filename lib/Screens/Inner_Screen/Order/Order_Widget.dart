import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Providers/user_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/ordered_product.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:gadaelectronics_user/models/address_model.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:gadaelectronics_user/models/order_model.dart';
import 'package:gadaelectronics_user/models/user_model.dart';
import 'package:provider/provider.dart';

class OrderWidgetFree extends StatefulWidget {
  const OrderWidgetFree({super.key,required this.orderId});
  final String orderId;

  @override
  State<OrderWidgetFree> createState() => _OrderWidgetFreeState();
}

class _OrderWidgetFreeState extends State<OrderWidgetFree> {
  AddressModel? userAddress;
  Set<CartModel> productList = {};
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  bool _isLoading = true;

  Future<void> fetchUserInfo()async{
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context);
    OrderModel orderDetail = orderProvider.getOrderList[widget.orderId]!;
    try{
      Map<String, AddressModel>? addressList = await addressProvider.fetchAddressList(orderDetail.addressId, orderDetail.userId);
      for(var element in addressList.values)
      {
        if(element.addressId==orderDetail.addressId)
        {
          userAddress = AddressModel(
              addressId: element.addressId,
              name: element.name,
              contactNo: element.contactNo,
              address: element.address,
              city: element.city
          );
        }
      }
      Set<CartModel> products = await orderProvider.getUserProducts(widget.orderId);

      setState(() {
        // Update productList with unique products
        productList = products;
      });
      userModel = await userProvider.fetchUserInfo();
    }
    catch(error){
      await MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: error.toString(),
          fct: (){}
      );
    }
    finally{
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context);
    OrderModel orderDetail = orderProvider.getOrderList[widget.orderId]!;


    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: fetchUserInfo(),
      builder: (context, snapshot) {
        try{
          return GestureDetector(
            onTap: () async{
              try{
                showModalBottomSheet<dynamic>(
                  elevation: 10,
                  useSafeArea: true,
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: size.height*0.9),
                  showDragHandle: true,
                  enableDrag: true,
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Name:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 1,),
                                      Expanded(
                                        child: Text(userAddress!.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Contact:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 1,),
                                      Expanded(
                                        child: Text(userAddress!.contactNo,style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold)),flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Email:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 1,),
                                      Expanded(
                                        child: Text(userModel!.userEmail,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)), flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text("Address:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 1,),
                                      Expanded(
                                        child: Text(userAddress!.address,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,right: 15),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("City:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 1,),
                                      Expanded(
                                        child: Text(userAddress!.city,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),flex: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:productList?.length ?? 0,
                                    itemBuilder:(context,index) {
                                      CartModel? product = productList.elementAt(index);
                                      if (product != null) {
                                        return ChangeNotifierProvider.value(
                                          child: OrderedProduct(
                                            productId: product.productId,
                                            qty: product.quantity,
                                          ),
                                          value: product,
                                        );
                                      }
                                    }
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    SizedBox(width: size.width*0.4,),
                                    Column(
                                      children: [
                                        SizedBox(
                                          child: Divider(thickness: 2,),
                                          width: size.width*0.55,
                                        ),
                                        Row(
                                          children: [
                                            TitleTextWidget(label: "Total Amount: ",fontsize: 16,),
                                            TitleTextWidget(label: "₹${orderDetail.totalAmount.toString()}0",fontsize: 16,color: Colors.blue,)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            TitleTextWidget(label: "Total Qty: ",fontsize: 16,),
                                            TitleTextWidget(label: "${orderDetail.totalProductQut.toString()}       ",fontsize: 16,color: Colors.blue,)
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ) ,
                        ),
                      ),
                    );
                  },
                );
              }
              catch(error)
              {
                MyAppFunction.showErrororWarnig(context: context, subTitel: error.toString(), fct: (){});
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      '${AssetManager.imgPath}/T1.png',
                      width: size.width*0.15,
                      height: size.width*0.15,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                      child: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TitleTextWidget(label: "Ordered Name: ",fontsize: 16,color: Colors.black,),
                                  Flexible(
                                      child: TitleTextWidget(label: userAddress!.name==null?"":userAddress!.name,fontsize: 16,color: Colors.black,)
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                TitleTextWidget(label: "Total Price: ", fontsize: 14, color: Colors.black,),
                                Flexible(child: SubtitleTextWidget(label: "₹${orderDetail.totalAmount.toString()}0", fontsize: 14, color: Colors.blue,)),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                TitleTextWidget(label: "Total Product Quntity: ", fontsize: 14, color: Colors.black,),
                                Flexible(child: SubtitleTextWidget(label: "${orderDetail.totalProductQut}", fontsize: 14, color: Colors.blue,)),
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
          );
        }
        catch(e){
          return Center(
            child: Container(
              height: size.height*0.15,
              alignment: Alignment.center,
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(color: Colors.orange,),
              ),
            ),
          );
        }
      },
    );
  }
}