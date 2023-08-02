

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButton extends StatelessWidget {
  final Function fct;
  final String buttonText;
  final Color primary;
  const AuthButton({Key? key, required this.fct, required this.buttonText, this.primary =Colors.white38}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
         backgroundColor: primary,
        ),
          onPressed: (){
        fct ();
      }, child: Text(
      buttonText,style: GoogleFonts.rubik(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500
      ),
      )),
    );
  }
}
