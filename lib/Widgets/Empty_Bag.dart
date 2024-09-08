import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Root_Screen.dart';
import 'package:gadaelectronics_user/Screens/HomeScreen.dart';
import 'package:gadaelectronics_user/Screens/Search_Screen.dart';

import 'Subtitle_text.dart';
import 'Title_Text.dart';
import '../Services/Asset_Manager.dart';

class EmptyBag extends StatelessWidget {

  const EmptyBag({super.key,required this.imgPath,required this.title,required this.subTitle,required this.buttonText,});
  final String imgPath,title,subTitle ;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(

      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50,),

          Image.asset(imgPath,width:double.infinity ,
            height: size.height*0.30,),

          SizedBox(height: 20,),
          TitleTextWidget(label: "Whoops!!!",fontsize: 40,color: Colors.orange,),
          SizedBox(height: 20,),

          SubtitleTextWidget(label: title,fontWeight:FontWeight.w600,fontsize: 20,),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(child: Text( subTitle,style: TextStyle(fontWeight:FontWeight.w400, fontSize: 15,),textAlign: TextAlign.justify,))
          ),
          SizedBox(height: 30,),
          buttonText!.isNotEmpty ? ElevatedButton(onPressed: (){Navigator.pushNamed(context, RootScreen.routName);}, child: Text(buttonText!)):SizedBox(height: 30,),
        ],
      ),
    );
  }
}
