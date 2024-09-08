import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gadaelectronics_user/Const/validator.dart';
import 'package:gadaelectronics_user/Screens/loading_manager.dart';
import 'package:gadaelectronics_user/Services/Asset_Manager.dart';
import 'package:gadaelectronics_user/Services/MyApp_Function.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routName = '/ForgotPasswordScreen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _emailController;
  late final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  @override
  void initState(){
    _emailController = TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    if(mounted)
    {
      _emailController.dispose();
    }
    super.dispose();
  }
  Future<void> _forgotPassFCT()async{
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid)
    {
      if(_emailController.text.isEmpty || !_emailController.text.contains("@"))
      {
        MyAppFunction.showErrororWarnig(
          context: context,
          subTitel: "Enter Valid Password",
          fct: (){}
        );
      }
      else
      {
        setState(() {
          _isLoading = true;
        });
        try
        {
          await _auth.sendPasswordResetEmail(email: _emailController.text.toLowerCase());
        } on FirebaseException
        catch(error)
        {
          MyAppFunction.showErrororWarnig(
            context: context,
            subTitel: "${error}",
            fct: (){}
          );
          setState(() {
            _isLoading = false;
          });
        }
        finally
        {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }  
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: LoadingManager(
            isLoading: _isLoading,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 10,),
                Image.asset('${AssetManager.imgPath}/R1.png',width: size.width*0.6,height: size.width*0.6,),
                SizedBox(height: 10,),
                TitleTextWidget(label: "Forgot Password",fontsize: 25,),
                SubtitleTextWidget(label: "Please enter the Email address wloud you like to reset your password",fontsize: 14,),
                SizedBox(height: 40,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "YourEmail@email.com",
                          prefixIcon: Container(padding: EdgeInsets.all(12),child: Icon(IconlyLight.message)),
                          filled: true
                        ),
                        validator: (value) {
                          return MyValidators.emailValidator(value);
                        },
                      ),
                      SizedBox(height: 16,),

                    ],
                  )
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      await _forgotPassFCT();
                    },
                  icon: Icon(IconlyBold.send),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    label: Text("send",style: TextStyle(fontSize: 20),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
