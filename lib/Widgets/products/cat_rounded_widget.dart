import 'package:flutter/cupertino.dart';
import 'package:gadaelectronics_user/Screens/Search_Screen.dart';
import 'package:gadaelectronics_user/Widgets/Subtitle_text.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({super.key,required this.image,required this.name});
final String image,name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Image.asset(image,height: 50,width: 50,),
          SizedBox(height: 5,),
          SubtitleTextWidget(label: name,fontsize: 14,fontWeight: FontWeight.bold,)
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, SearchScreen.routName,arguments: name);
      },
    );
  }
}
