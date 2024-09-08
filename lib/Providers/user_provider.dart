import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadaelectronics_user/models/user_model.dart';

class UserProvider with ChangeNotifier{

  UserModel? userModel;
  UserModel? get getUserModel{
    return userModel;
  }

  Future<UserModel?> fetchUserInfo()async{
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if(user==null) {
      return null;
    }

    String uid = user.uid;
    try{
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final userDocDict = userDoc.data();

      userModel = UserModel(
          userId: userDoc.get("userId"),
          userName: userDoc.get("userName"),
          userEmail: userDoc.get("userEmail"),
          userImage: userDoc.get("userImage"),
          createAt: userDoc.get("createAt"),
          userCart: userDocDict!.containsKey("userCart")?userDoc.get("userCart"):[],
          userWish: userDocDict!.containsKey("userWish")?userDoc.get("userWish"):[]
      );
      return userModel;
    }on FirebaseException
    catch(error){
      rethrow;
    }
    catch(error){
      rethrow;
    }

  }

}