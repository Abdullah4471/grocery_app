import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/fetch_screen.dart';
import 'package:grocery_app/screens/bottom_bar_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/widgets/text_widget.dart';

import '../consts/firebase_const.dart';


class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
      final authResult=    await authInstance.signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
         if(authResult.additionalUserInfo!.isNewUser){
           await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set(
               {
                 'id': authResult.user!.uid,
                 'name':authResult.user!.displayName,
                 'email':authResult.user!.email,
                 'shipping-address':'',
                 'userWish':[],
                 'userCart':[],
                 'createAt':Timestamp.now(),

               }
           );
         }
        } on FirebaseException catch (error) {
          GlobalMethod.errorDialog(
              subTitle: '${error.message}', context: context, );
        } catch (error) {
          GlobalMethod.errorDialog(subTitle: '$error', context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/google.png',
              width: 40.0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          TextWidget(
              text: 'Sign in with google', color: Colors.white, textSize: 18)
        ]),
      ),
    );
  }
}
