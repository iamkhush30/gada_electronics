import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({super.key,required this.label,
    this.fontsize = 20,
    this.color,
    this.maxLines,
  });

  final String label;
  final double fontsize ;
  final Color? color ;
  final int? maxLines ;





  @override
  Widget build(BuildContext context) {
    return Text(label,maxLines:maxLines ,style: TextStyle(
        fontSize: fontsize,
        fontWeight: FontWeight.bold,
        color: color,
        overflow:TextOverflow.ellipsis ),);
  }
}
