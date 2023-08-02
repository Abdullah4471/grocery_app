import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/consts/firebase_const.dart';
import 'package:uuid/uuid.dart';

import '../widgets/text_widget.dart';

class GlobalMethod {
  static navigatTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog(
      {required String title,
      required String subTitle,
      required VoidCallback fct,
      required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/warning-sign.png",
                  height: 20,
                  width: 20,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(title)
              ],
            ),
            content: Text(subTitle),
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    text: "Cancel",
                    color: Colors.cyan,
                    textSize: 18,
                  )),
              TextButton(
                  onPressed: () {
                    fct();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    text: "Ok",
                    color: Colors.red,
                    textSize: 18,
                  ))
            ],
          );
        });
  }

  static Future<void> errorDialog(
      {required String subTitle, required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/warning-sign.png",
                  height: 20,
                  width: 20,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 8,
                ),
                Text("An error occurred")
              ],
            ),
            content: Text(subTitle),
            contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: TextWidget(
                    text: "Ok",
                    color: Colors.cyan,
                    textSize: 18,
                  )),
            ],
          );
        });
  }
  static Future<void> addToCart(
      {required String productId,
        required int quantity,
        required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      errorDialog(subTitle: error.toString(), context: context);
    }
  }
  static Future<void> addToWishlist(
      {required String productId, required BuildContext context}) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: "Item has been added to your wishlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } catch (error) {
      errorDialog(subTitle: error.toString(), context: context);
    }
  }
}
