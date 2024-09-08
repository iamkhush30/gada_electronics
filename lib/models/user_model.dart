import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';

class UserModel with ChangeNotifier{

  final String userId, userName, userImage, userEmail;
  final Timestamp createAt;
  final List userCart , userWish;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.createAt,
    required this.userCart,
    required this.userWish
  });

}