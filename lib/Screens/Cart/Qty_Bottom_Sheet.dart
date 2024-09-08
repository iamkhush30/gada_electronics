

import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:provider/provider.dart';

class QtyBottomSheet extends StatelessWidget {
  const QtyBottomSheet({super.key,required this.cartModel});
  final CartModel cartModel ;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        SizedBox(height: 20,),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),color: Colors.grey
          ),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
              itemCount: 25, itemBuilder: (context,index){
            return InkWell(
              child: Center(child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleTextWidget(label:"${index+1}"),
              )),
              onTap: ()async{
                print("-----------------------------------cartModel.cartId=${cartModel.productId}");
                print("-----------------------------------cartModel.productId=${cartModel.cartId}");
                print("-----------------------------------cartModel.qty=${index+1}");
                cartProvider.updateQty(cartId: cartModel.cartId, productId: cartModel.productId, qty: index+1, context: context);
                Navigator.pop(context);
              },
            );
          }),
        ),
      ],
    );
  }
}
