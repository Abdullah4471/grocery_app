import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/utils.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return InkWell(
      onTap: (){
        Navigator.canPop(context)?Navigator.pop(context):null;
      },
      borderRadius: BorderRadius.circular(12),
      child: Icon(
        CupertinoIcons.back,
        color: color,
      ),
    );
  }
}
