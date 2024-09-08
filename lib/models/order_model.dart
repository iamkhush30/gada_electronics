import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadaelectronics_user/models/cart_model.dart';

class OrderModel with ChangeNotifier{
  final String orderId;
  final String userId;
  Timestamp? orderTime;
  final List<dynamic> products ;
  final String addressId;
  final int totalProductQut;
  final double totalAmount;
  OrderModel({required this.orderId,required this.userId,required this.orderTime,required this.products,required this.addressId,required this.totalProductQut,required this.totalAmount});
}