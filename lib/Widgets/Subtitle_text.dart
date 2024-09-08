import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  const SubtitleTextWidget({super.key,required this.label,
    this.fontsize = 15,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none });

  final String label;
  final double fontsize ;
  final FontStyle fontStyle ;
  final FontWeight? fontWeight;
  final Color? color ;
  final TextDecoration textDecoration;


  @override
  Widget build(BuildContext context) {
    return Text(label,style: TextStyle(
        fontSize: fontsize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: color,
        fontStyle: fontStyle),);
  }
}
