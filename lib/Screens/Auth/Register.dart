import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as FStorage;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/HomeScreen.dart';
import 'package:gadaelectronics_user/Screens/Splash_Screen.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/auth/Submit_Button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Const/validator.dart';
import '../../Widgets/Subtitle_text.dart';
import '../../Widgets/Title_Text.dart';
import 'image_picker_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _emailController,_nameController,_passwordController,_repeatPasswordController;
  late final FocusNode _emailFocus,_nameFocus,_passwordFocus,_repeatPasswordFocus;
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool _isLoading = false;
  String profileImageURL = "";
  final auth = FirebaseAuth.instance;
  @override
  void initState(){
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _repeatPasswordFocus = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    if(mounted)
    {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      _nameFocus.dispose();
      _emailFocus.dispose();
      _passwordFocus.dispose();
      _repeatPasswordFocus.dispose();
    }
    super.dispose();
  }
  bool resultIcon = true;
  Future<bool> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    bool formResult;
    FocusScope.of(context).unfocus();
    User? currentUser;

    if(isValid){
      try{
        setState(() {
          _isLoading = true;
        });
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        );
        final User? user = auth.currentUser;
        final String uid = user!.uid;
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "userId" : uid,
          "userName" : _nameController.text,
          "userImage" : profileImageURL,
          "userEmail" : _emailController.text,
          "createAt" : Timestamp.now(),
          "userCart" : [],
          "userWish" : []
        });
        Fluttertoast.showToast(
            msg: "an Account has been created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        if(!mounted){
          setState(() {});
        }
        Navigator.pushReplacementNamed(context, RootScreen.routName);
      }
      on FirebaseException
      catch(error){
        await MyAppFunction.showErrororWarnig(
            context: context,
            subTitel: error.toString(),
            fct: (){

            }
        );
      }
      finally{
        setState(() {
          _isLoading = false;
        });
      }
    }
    return formResult = isValid ;
  }

  bool rememberMe = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppFunction.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 25,);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 25);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Sign up",style: TextStyle(fontSize: 15,color: Colors.grey),),backgroundColor: Colors.transparent,),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleTextWidget(label: "Welcome to Gada Electronics",fontsize: 20),
                const SizedBox(height: 20,),
                SizedBox(
                  height: size.width*0.3,
                  width: size.width*0.3,
                  child: PickImageWidget(pickedImage:_pickedImage,function: ()async{
                    await localImagePicker();
                  }),
                ),
                const SizedBox(height: 20,),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),//textfeild padding yes or no
                        child: TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                            //borderlands yes or no
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person,),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocus);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),//textfeild padding yes or no
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50),)),
                            //borderlands yes or no
                            hintText: "Email Address",
                            prefixIcon: Icon(IconlyLight.message,),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocus);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),//textfeild padding yes or no
                        child: TextFormField(
                          obscureText: passwordVisible,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            //border-radius yes or no
                            hintText: "Password",
                            prefixIcon: Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {passwordVisible = !passwordVisible;});
                              },
                              icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility )
                            )
                          ),
                          onFieldSubmitted: (value) async {
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocus);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),//textfeild padding yes or no
                        child: TextFormField(
                          obscureText: confirmPasswordVisible,
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocus,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            //border-radius yes or no
                            hintText: "Confirm Password",
                            prefixIcon: Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {confirmPasswordVisible = !confirmPasswordVisible;});
                              },
                              icon: Icon(confirmPasswordVisible ? Icons.visibility_off : Icons.visibility )
                            )
                          ),
                          onFieldSubmitted: (value) async {
                            await _registerFct();
                          },
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(value:value,password: _passwordController.text);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox (
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0,left: 50.0),// padding yes or no
                          child: SubmitButton(
                            function: () async{
                              if(_pickedImage!=null)
                              {
                                String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                                FStorage.Reference storageRef = FStorage.FirebaseStorage.instance.ref().child("UserProfileImage").child(fileName);
                                FStorage.UploadTask uploadImageTask = storageRef.putFile(File(_pickedImage!.path));
                                FStorage.TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete((){});
                                await taskSnapshot.ref.getDownloadURL().then((urlImage){
                                  profileImageURL = urlImage;
                                });
                              }
                              else{
                                Fluttertoast.showToast(msg: "Please Selected an image");
                              }
                              await _registerFct() ? resultIcon = true : resultIcon = false ;
                            },
                            label: "Sign up",
                            resultOutput: resultIcon,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}