


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double textSize;
  bool isTitle;
  int maxLine =10;
   TextWidget({Key? key, required this.text, required this.color, required this.textSize,this.isTitle =false,this.maxLine=10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.lato(fontSize: textSize,fontWeight: isTitle ?FontWeight.bold: FontWeight.normal,color:color));
  }
}
