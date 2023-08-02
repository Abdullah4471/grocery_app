import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widget.dart';

class EmptyScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final String buttonText;
  const EmptyScreen({Key? key, required this.imagePath, required this.title, required this.subTitle, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Utils(context).getTheme;
    final Utils utils = Utils(context);
    final Color color =Utils(context).color;
    final Size size = utils.getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height *.1,),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              TextWidget(
                text: "Whoops!",
                color: Colors.red,
                textSize: 40,
                isTitle: true,
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextWidget(
                text: title,
                color: Colors.cyan,
                textSize: 20,
                isTitle: false,
              ),
              SizedBox(height: size.height *0.01,),
              TextWidget(
                text: subTitle,
                color: Colors.cyan,
                textSize: 20,
                isTitle: false,
              ),
              SizedBox(height: size.height *.1,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: color)
                  ),
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: color,
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                ),
                  onPressed: () {
                    GlobalMethod.navigatTo(
                        ctx: context, routeName: FeedsScreen.routeName);
                  },
                  child: TextWidget(
                    text: buttonText,
                    textSize: 20,
                    isTitle: true,
                    color: themeState? Colors.grey.shade300:Colors.grey.shade800,
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}
