


import 'package:flutter/material.dart';
import 'package:grocery_app/services/utils.dart';

class EmptyProductScreen extends StatelessWidget {
  final String tileText;
  const EmptyProductScreen({Key? key, required this.tileText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color =Utils(context).color;
    return Center(
      child: Column(
        children: [
          SizedBox(height: 60,),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(
              "assets/images/box.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              tileText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
