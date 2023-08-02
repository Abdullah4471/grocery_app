import 'package:flutter/material.dart';
import 'package:grocery_app/inner_screen/cat_screen.dart';
import 'package:grocery_app/provider/dark_them_provider.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final String catText, imagePath;
  final Color passedcolor ;

   CategoryWidget({Key? key, required this.catText, required this.imagePath, required this.passedcolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double _screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: passedcolor.withOpacity(0.1),
          border: Border.all(color: passedcolor.withOpacity(0.7), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * 0.3,
              width: _screenWidth * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            TextWidget(text: catText, color: color, textSize: 22)
          ],
        ),
      ),
    );
  }
}
