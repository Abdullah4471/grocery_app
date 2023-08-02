
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({Key? key, required this.isLoading, required this.child}) : super(key: key);
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          child,
          isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: SpinKitFadingCube(

                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      );
  }
}
