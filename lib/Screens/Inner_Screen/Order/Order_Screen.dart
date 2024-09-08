import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/order_provider.dart';
import 'package:gadaelectronics_user/Screens/loading_manager.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';
import 'package:gadaelectronics_user/Widgets/App_Name_Text.dart';
import 'package:gadaelectronics_user/Widgets/Empty_Bag.dart';
import 'package:provider/provider.dart';

import 'Order_Widget.dart';

class OrderScreen extends StatefulWidget {
  static const routName = '/OrderScreen';
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orderIds = orderProvider.getOrderList.keys.toList();
    return Scaffold(
      appBar: AppBar(title: AppNameText(fontSize: 25,),backgroundColor: Colors.transparent,),
      body: orderProvider.getOrderList.isEmpty
          ? const EmptyBag(imgPath: "assets/images/T1.png",title: "No Order has been Placed yet", subTitle: "",buttonText: "",)
          : ListView.separated(itemBuilder: (ctx,index){
        return ChangeNotifierProvider.value(
          value: orderProvider.getOrderList.values.toList()[index],
          child: Card(
            elevation: 7,
            shadowColor: Colors.white,
            color: Colors.white,
            child: OrderWidgetFree(orderId: orderIds[index]),
          ),
        );
      },
          separatorBuilder: (BuildContext context, int index){
            return  Divider(thickness: 5,color: Theme.of(context).scaffoldBackgroundColor,);
          }, itemCount: orderProvider.getOrderList.values.length),
    );
  }
}
