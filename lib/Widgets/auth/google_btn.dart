import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {

  Future<void> _googleSignin ({required BuildContext context}) async{
    try{
      final User? user = FirebaseAuth.instance.currentUser;
      if(user==null)
      {
        final googleSignIn = GoogleSignIn();
        final googleAccount = await googleSignIn.signIn();
        print("-------------------------------------${googleAccount.toString()}");

        if (googleAccount != null) {
          final googleAuth = await googleAccount.authentication;
          final authResult = await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          );

          final User? user = authResult.user;

          if (user != null) {
            await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
              "userId": user.uid,
              "userName": user.displayName,
              "userImage": user.photoURL,
              "userEmail": user.email,
              "createAt": Timestamp.now(),
              "userCart": [],
              "userWish": [],
            });
          }
        }
        if(!context.mounted) return ;
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Fluttertoast.showToast(msg: "Log in Succsesfully");
          Navigator.pushReplacementNamed(context, RootScreen.routName);
        });
      }
      else{
        await FirebaseAuth.instance.signOut();
      }
    }
    on FirebaseException
    catch(error){
      await MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: error.message.toString(),
          fct: (){}
      );
    }
    catch(error){
      await MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: error.toString(),
          fct: (){}
      );}
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Colors.purple,
        padding: const EdgeInsets.all(12.0),//padding yes or no
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0,),),
      ),
      child: Image(image: AssetImage("assets/images/google_logo.png"),height: 50),
      onPressed: () async {
        await _googleSignin(context: context);
      },
    );
  }
}

