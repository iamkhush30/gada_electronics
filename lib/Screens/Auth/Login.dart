import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gadaelectronics_user/Const/App_const.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/Auth/Forgot_Password.dart';
import 'package:gadaelectronics_user/Screens/Auth/Register.dart';
import 'package:gadaelectronics_user/Screens/HomeScreen.dart';
import 'package:gadaelectronics_user/Screens/Splash_Screen.dart';
import 'package:gadaelectronics_user/Screens/loading_manager.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/auth/Submit_Button.dart';
import 'package:gadaelectronics_user/Widgets/auth/google_btn.dart';

import '../../Const/validator.dart';
import '../../Widgets/Subtitle_text.dart';
import '../../Widgets/Title_Text.dart';

class Login extends StatefulWidget {
  static const routName = "/Login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  @override
  void initState(){
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    super.initState();
  }
  @override
  void dispose(){
    if(mounted)
    {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocus.dispose();
      _passwordFocus.dispose();
    }
    super.dispose();
  }
  bool resultIcon = true ;
  Future<void> _loginFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    User? currentUser;

    if(isValid){
      try{
        setState(() { _isLoading = true; });
        await auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        );
        Fluttertoast.showToast(msg: "Login Successfully");

        if(!mounted) return;

        Navigator.pushReplacementNamed(context, RootScreen.routName);
      }on FirebaseException catch(error){
        await MyAppFunction.showErrororWarnig(
            context: context,
            subTitel: error.message.toString(),
            fct: (){}
        );
      } catch(error){
        await MyAppFunction.showErrororWarnig(
            context: context,
            subTitel: error.toString(),
            fct: (){}
        );
      } finally{
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool passwordVisible = true;
  //bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{ return false; },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LoadingManager(
          isLoading: _isLoading,
          child: Scaffold(
          appBar: AppBar(
            title: Text("Log in",style: TextStyle(fontSize: 15,color: Colors.grey),),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/I1.png",height: 175,),//image size format your mobile
                    const SizedBox(height: 16,),
                    TitleTextWidget(label: "Welcome Back",fontsize: 25),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                prefixIcon: Icon(
                                  IconlyLight.message,
                                ),
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

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
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
                                await _loginFct();
                              },
                              validator: (value) {
                                return MyValidators.passwordValidator(value);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.centerRight,//padding yes or no
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(ForgotPasswordScreen.routName);
                                },
                                child: const SubtitleTextWidget(
                                  label: "Forgot Password?",
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 50.0,left: 50.0),// padding yes or no
                              child: SubmitButton(
                                function: () async{
                                  await _loginFct();
                                },
                                label: "Log in",
                                resultOutput: resultIcon,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SubtitleTextWidget(
                            label: "───── Or ─────".toUpperCase(),
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: kBottomNavigationBarHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: kBottomNavigationBarHeight-10,
                                  child: FittedBox(child: GoogleButton())
                                ),
                                SizedBox(width: 25),
                                SizedBox(
                                  height: kBottomNavigationBarHeight-10,
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      shadowColor: Colors.purple,
                                      // backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0,),),
                                    ),
                                    child: const Text("Guest?",style: TextStyle(fontSize: 15,)),
                                    onPressed: () async{
                                      //Navigator.of(context, rootNavigator: true).pushNamed(RootScreen.routName);
                                      await Navigator.of(context).pushNamed(RootScreen.routName);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(label: "New Here ?"),
                              TextButton(
                                onPressed: () async{
                                  await Navigator.of(context).pushNamed(RegisterScreen.routName);
                                },
                                child: const SubtitleTextWidget(
                                  label: "Sign up",
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


