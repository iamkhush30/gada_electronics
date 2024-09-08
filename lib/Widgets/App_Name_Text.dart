import 'package:flutter/material.dart';
import 'package:gadaelectronics_user/Widgets/Title_Text.dart';
import 'package:shimmer/shimmer.dart';

class AppNameText extends StatelessWidget {
  const AppNameText({super.key,this.fontSize=30});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor:Colors.orange,
        highlightColor:Colors.yellow,
        period: Duration(seconds: 3),
        child: TitleTextWidget(label: "Gada Electronics",fontsize: fontSize,),
    );
  }
}
