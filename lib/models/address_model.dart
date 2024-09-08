import 'package:flutter/cupertino.dart';

class AddressModel with ChangeNotifier{
  final String addressId;
  final String name;
  final String contactNo;
  final String address;
  final String city;
  AddressModel({required this.addressId,required this.name,required this.contactNo,required this.address,required this.city});
}