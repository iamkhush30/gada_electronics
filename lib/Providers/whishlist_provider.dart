import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/models/Wishlist_Model.dart';
import 'package:uuid/uuid.dart';

import '../Services/MyApp_Function.dart';
import '../models/cart_model.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishLists {
    return _wishlistItems;
  }

  WishlistModel? findWishlistIdByProductId (String productId){

    if(_wishlistItems.values.where((element) => element.productId==productId).isEmpty){
      return null;
    }
    return _wishlistItems.values.firstWhere((element) => element.productId==productId);
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addtowhishlist({required String productId,required BuildContext context})async{
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
    final whishlistId = Uuid().v4();
    try{
      await userDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([{
          'whishlistId': whishlistId,
          'productId': productId,
        }])
      });
      await fetchWishlist();
      Fluttertoast.showToast(msg: "Product has been added");
    } catch(error){
      rethrow;
    }
  }

  Future<void> fetchWishlist ()async{
    final User? user = _auth.currentUser;

    if(user==null) {
      _wishlistItems.clear();
      return;
    }

    try{
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();

      if(data==null || !data.containsKey('userWish')){
        return;
      }

      final cartLen = userDoc.get('userWish').length;

      for(int index=0; index<cartLen ; index++){
        _wishlistItems.putIfAbsent(userDoc.get('userWish')[index]['productId'], () => WishlistModel(
            wishlistId: userDoc.get("userWish")[index]['whishlistId'],
            productId: userDoc.get("userWish")[index]['productId'])
        );
      }

    } catch(error){
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWhishlistfromFirebase({required String whishlistId,required String productId})async {
    final User? user = _auth.currentUser;
    try{
      await userDB.doc(user!.uid).update({
        'userWish':FieldValue.arrayRemove([{
          'whishlistId':whishlistId,
          'productId':productId,
        }])
      });
      _wishlistItems.remove(productId);
      Fluttertoast.showToast(msg: 'Product hase been remove from wishlist');
    }
    catch(error){
      rethrow;
    }
  }

  Future<void> clearWhishlistfromFirebase()async{
    final User? user = _auth.currentUser;
    try{
      await userDB.doc(user!.uid).update({
        'userWish':[]
      });
      //await fetchCart();
      _wishlistItems.clear();
      Fluttertoast.showToast(msg: 'Wishlist Has Been Cleared');
    }
    catch(e){
      rethrow;
    }
  }

  void addRemoveFromWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.putIfAbsent(productId, () =>
          WishlistModel(wishlistId: Uuid().v4(), productId: productId),);
    }
  }

  notifyListeners();


  bool isProdinWishList({required String productId}) {
    return _wishlistItems.containsKey(productId);
  }


  void clearLocalWishList() {
    _wishlistItems.clear();
    notifyListeners();
  }
}