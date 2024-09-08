import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Providers/cart_provider.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';
import 'package:provider/provider.dart';

class QtyCounter extends StatefulWidget {
  const QtyCounter({super.key,required this.cartModel});
  final CartModel cartModel;

  @override
  State<QtyCounter> createState() => _QtyCounterState();
}

class _QtyCounterState extends State<QtyCounter> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    int? quantity = cartProvider.getProductQty(widget.cartModel.productId);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          ),

      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft: Radius.circular(20)),
              color: Colors.blue.shade900,
            ),
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () async{
                  if(quantity!>1)
                  {
                    setState(() {
                      quantity = quantity! - 1;
                    });
                    print("--------------------------------------$quantity");
                    await cartProvider.updateQty(cartId: widget.cartModel.cartId, productId: widget.cartModel.productId, qty: quantity!, context: context);
                    setState(() {
                      quantity = cartProvider.getProductQty(widget.cartModel.productId);
                    });
                  }
                },
                icon: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 18,
                ),
            ),
          ),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(color: Colors.blue.shade900,),
            alignment: Alignment.center,
            child: Container(
              height: 30,
              width: 30,
              alignment: Alignment.center ,
              margin: EdgeInsets.symmetric(horizontal: 3),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white,),
              child: Text(quantity.toString(),style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20)),
              color: Colors.blue.shade900,
            ),

            alignment: Alignment.center,
            child: IconButton(
              onPressed: () async{
                if(quantity!<25)
                {
                  setState(() {
                    quantity = quantity! + 1 ;
                  });
                  print("--------------------------------------$quantity");
                  await cartProvider.updateQty(cartId: widget.cartModel.cartId, productId: widget.cartModel.productId, qty: quantity!, context: context);
                  setState(() {
                    quantity = cartProvider.getProductQty(widget.cartModel.productId);
                  });
                }
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 18,
              )
            ),
          )
        ],
      ),
    );
  }
}
