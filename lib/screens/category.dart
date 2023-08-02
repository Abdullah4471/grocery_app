import 'package:flutter/material.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/category_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> gridColor = [
      Color(0xff53b175),
      Color(0xfff8a44c),
      Color(0xfff7a593),
      Color(0xffd3b0e0),
      Color(0xfffde998),
      Color(0xffb7dff5),
    ];

    final List<Map<String, dynamic>> catInfo = [
      {'imagePath': 'assets/images/cat/fruits.png', "catText": 'Fruits'},
      {
        'imagePath': 'assets/images/cat/veg.png',
        'catText': 'Vegetable',
      },
      {
        'imagePath': 'assets/images/cat/Spinach.png',
        "catText": "Herbs",
      },
      {
        'imagePath': 'assets/images/cat/nuts.png',
        "catText": "Nuts",
      },
      {
        'imagePath': 'assets/images/cat/spices.png',
        "catText": "Spices",
      },
      {
        'imagePath': 'assets/images/cat/grains.png',
        "catText": "Grains",
      }
    ];

    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          textSize: 22,
          text: "Category",
          color: color,
          isTitle: true,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(

          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(6, (index) {
            return CategoryWidget(
                catText: catInfo[index]['catText'],
                imagePath: catInfo[index]['imagePath'],
                passedcolor: gridColor[index]);
          }),
        ),
      ),
    );
  }
}
