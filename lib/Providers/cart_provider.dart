 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Providers/Products_Providers.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:uuid/uuid.dart';

import '../models/cart_model.dart';

class CartProvider with ChangeNotifier{

  final Map<String,CartModel> _cartItems={};

  Map<String,CartModel> get getCartItems{
    return _cartItems;
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addtoCart({required String productId,required int qty,required BuildContext context})async{
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
    final cartId = Uuid().v4();
    try{
      await userDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([{
          'cartId': cartId,
          'productId': productId,
          'quantity': qty,
        }])
      });
      await fetchCart();
      Fluttertoast.showToast(msg: "Product has been added");
    } catch(error){
      rethrow;
    }
  }

  Future<void> updateQty({required String cartId,required String productId,required int qty,required BuildContext context})async{
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
    try{
      DocumentSnapshot  userDoc = await userDB.doc(user.uid).get();
      List userCart = userDoc['userCart'];
      int index = userCart.indexWhere((item) => item['cartId'] == cartId);
      if (index != -1)
      {
        userCart[index]['quantity'] = qty;

        await userDB.doc(uid).update({'userCart': userCart});

        await fetchCart();

        if (_cartItems.containsKey(productId)) {
          _cartItems[productId] = CartModel.copyWithQuantity(_cartItems[productId]!, qty);
        }
      }
      else {
        print('Item not found in Cart.');
      }
      await fetchCart();
      getQty();
    } catch(error){
      rethrow;
    }
  }
  
  Future<void> fetchCart ()async{
    final User? user = _auth.currentUser;

    if(user==null) {
      _cartItems.clear();
      return;
    }
    
    try{
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      
      if(data==null || !data.containsKey('userCart')){
        return;
      }
      
      final cartLen = userDoc.get('userCart').length;
      
      for(int index=0; index<cartLen ; index++){
        _cartItems.putIfAbsent(userDoc.get('userCart')[index]['productId'], () => CartModel(
            cartId: userDoc.get('userCart')[index]['cartId'],
            orderId: '',
            productId: userDoc.get('userCart')[index]['productId'],
            quantity: userDoc.get('userCart')[index]['quantity']
        ));
      }

    } catch(error){
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartfromFirebase({required String cartId,required String productId,required int qty})async {
    final User? user = _auth.currentUser;
    try{
      await userDB.doc(user!.uid).update({
        'userCart':FieldValue.arrayRemove([{
          'cartId':cartId,
          'productId':productId,
          'quantity':qty,
        }])
      });
      //await fetchCart();
      _cartItems.remove(productId);
      Fluttertoast.showToast(msg: 'Items Has Been Removed');
    }
    catch(e){
      rethrow;
    }
  }

  Future<void> clearCartfromFirebase()async{
    final User? user = _auth.currentUser;
    try{
      await userDB.doc(user!.uid).update({
        'userCart':[]
      });
      //await fetchCart();
      _cartItems.clear();
      Fluttertoast.showToast(msg: 'Cart Has Been Cleared');
    }
    catch(e){
      rethrow;
    }
  }





  bool isProdinCart({required String productId}){
    return _cartItems.containsKey(productId);
  }

  double getTotal({required ProductProvider productProvider}){
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findByProductId(value.productId);
      if(getCurrProduct==null)
      {
        total+=0;
      }
      else
      {
        total+=double.parse(getCurrProduct.productPrice)*value.quantity!.toInt();
      }
    });

    return total;
  }

  List<String> getProductsId(){
    List<String> productsID=[];
    _cartItems.forEach((key, value) {
      productsID.add(value.productId);
    });
    return productsID;
  }

  int? getProductQty(String productId){
    int? qty = 1;
    _cartItems.forEach((key, value) {
      if(value.productId==productId)
      {
        qty = value.quantity;
      }
    });
    return qty;
  }

  int getQty(){
    int total = 0;
    _cartItems.forEach((key, value) {total+=value.quantity!;});

    return total;
  }

  void clearLocalCart(){
    _cartItems.clear();
    notifyListeners();
  }

  void removeOneItem({required String productId}){
    _cartItems.remove(productId);
    notifyListeners();
  }



}