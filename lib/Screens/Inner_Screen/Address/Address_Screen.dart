import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/address_provider.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Address/Add_Address.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Address/Address_Details.dart';
import 'package:gadaelectronics_user/Screens/Inner_Screen/Order/Order_Screen.dart';
import 'package:gadaelectronics_user/Widgets/App_Name_Text.dart';
import 'package:gadaelectronics_user/Widgets/Empty_Bag.dart';
import 'package:provider/provider.dart';
class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}
class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final List addressId = addressProvider.getAddressList.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: AppNameText(fontSize: 25,),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddress(),));
        },
        icon: Icon(Icons.add_location),
        label: Text("Add New Address")
      ),
      body: addressProvider.getAddressList.isEmpty ? EmptyBag(
          imgPath: "assets/images/A2.png",
          title: "Empty Address",
          subTitle: "",
          buttonText: "add address"
      ) :
      Column(
        children: [
          Consumer<AddressProvider>(builder: (context,addressProvider,child){
            return Flexible(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView.separated(
                  itemCount: addressProvider.getAddressList.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: addressProvider.getAddressList.values.toList()[index],
                      child: Card(
                        elevation: 7,
                        shadowColor: Colors.white,
                        color: Colors.white,
                        child: GestureDetector(
                          child: AddressDetail(index: index),
                          onTap: ()async{
                            await orderProvider.placeOrder(
                              addressId: addressId[index],
                              context: context,
                            );
                            await orderProvider.removeUserProduct();
                            await orderProvider.fetchOrder();
                          },
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 5,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    );
                  },
                ),
              ),
            );
            },
          )
        ],
      ),
    );
  }
}
