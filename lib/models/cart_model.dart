 import 'package:flutter/cupertino.dart';

class CartModel with ChangeNotifier{
  final String cartId;
  final String orderId;
  final String productId;
  final int? quantity;
  CartModel({required this.cartId,required this.productId,required this.quantity, required this.orderId});

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
    };
  }

  CartModel.copyWithQuantity(CartModel cartModel, int newQty): cartId = cartModel.cartId,orderId = "", productId = cartModel.productId, quantity = newQty;

}