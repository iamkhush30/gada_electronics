import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/models/address_model.dart';
import 'package:uuid/uuid.dart';

class AddressProvider with ChangeNotifier {

  final Map<String, AddressModel> _addressItems = {};

  Map<String, AddressModel> get getAddressList {
    return _addressItems;
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Stream<Map<String, AddressModel>> fetchAddressStream(){
    try{

      return userDB.snapshots().map((snapshot) {
        _addressItems.clear();
        for(var element in snapshot.docs){
          Map data = element.data() as Map<String,dynamic>;
          _addressItems.putIfAbsent(data['addressId'], () =>
            AddressModel(
              addressId: data['addressId'],
              name: data['addressId'],
              contactNo: data['addressId'],
              address: data['addressId'],
              city: data['addressId']
            )
          );
        }
        return _addressItems;
      });
    } catch(error){
      rethrow;
    }
  }

  Future<void> addNewAddress({required String name,required String contactNo,required String address,required String city,required BuildContext context})async{
    final User? user = _auth.currentUser;

    if(user==null) {
      MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: "Please Login first",
          fct: (){}
      );
      return;
    }
    final uid = user.uid;
    final addressId = Uuid().v4();
    try{
      await userDB.doc(uid).update({
        'userAddress': FieldValue.arrayUnion([{
          'addressId': addressId,
          'name': name,
          'contactNo': contactNo,
          'address': address,
          'city': city,
        }])
      });
      await fetchAddress();
      Fluttertoast.showToast(msg: "New Address has been added");
    } catch(error){
      rethrow;
    }
  }

  Future<void> fetchAddress ()async{
    final User? user = _auth.currentUser;

    if(user==null) {
      _addressItems.clear();
      return ;
    }

    try{
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();

      if(data==null || !data.containsKey('userAddress')){
        return ;
      }

      final cartLen = userDoc.get('userAddress').length;

      for(int index=0; index<cartLen ; index++) {
        _addressItems.putIfAbsent(
          userDoc.get('userAddress')[index]['addressId'], () =>
            AddressModel(
              addressId: userDoc.get('userAddress')[index]['addressId'],
              name: userDoc.get('userAddress')[index]['name'],
              contactNo: userDoc.get('userAddress')[index]['contactNo'],
              address: userDoc.get('userAddress')[index]['address'],
           city: userDoc.get('userAddress')[index]['city'],
        ));
      }
    } catch(error){
      rethrow;
    }
    notifyListeners();
  }

  Future<Map<String, AddressModel>> fetchAddressList(String addressId, String userId)async{
    final User? user = _auth.currentUser;

    if(user==null) {
      _addressItems.clear();
      return {};
    }

    try{
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();

      if (data == null || !data.containsKey('userAddress')) {
        return {}; // or return an empty map based on your requirement
      }

      final addressList = userDoc.get('userAddress');

      for (int index = 0; index < addressList.length; index++) {
        final addressData = addressList[index];

        if (addressId == addressData['addressId']) {
          _addressItems.putIfAbsent(
            addressData['addressId'],
                () => AddressModel(
              addressId: addressData['addressId'],
              name: addressData['name'],
              contactNo: addressData['contactNo'],
              address: addressData['address'],
              city: addressData['city'],
            ),
          );
        }
      }
    } catch(error){
      rethrow;
    }
    notifyListeners();
    return _addressItems;
  }

  Future<void> removeAddressfromFirebase({required String addressId,required String name,required String contactNo,required String address,required String city})async {
    final User? user = _auth.currentUser;
    try{
      await userDB.doc(user!.uid).update({
        'userAddress':FieldValue.arrayRemove([{
          'addressId': addressId,
          'name': name,
          'contactNo': contactNo,
          'address': address,
          'city': city,
        }])
      });
      await fetchAddress();
      _addressItems.remove(addressId);
      Fluttertoast.showToast(msg: 'Items Has Been Removed Successfully');
    }
    catch(e){
      rethrow;
    }
  }

}