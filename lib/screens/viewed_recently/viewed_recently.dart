import 'package:flutter/cupertino.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/screens/viewed_recently/viewed_widget.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/empty_screen.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../services/globle_method.dart';

class ViewedScreen extends StatefulWidget {
  static const routeName = '/ViewedScreen';
  const ViewedScreen({Key? key}) : super(key: key);

  @override
  State<ViewedScreen> createState() => _ViewedScreenState();
}

class _ViewedScreenState extends State<ViewedScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemList = viewedProdProvider.getViewedProdListItems.values.toList().reversed.toList();

    // bool _isEmpty = true;

    if (viewedProdItemList.isEmpty)
      return EmptyScreen(
          imagePath: "assets/images/history.png",
          title: "Your history is empty",
          subTitle: "No product has been viewed yet!",
          buttonText: "Shop now");
    else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: color,
            ),
          ),
          title: TextWidget(
            text: "History",
            textSize: 20,
            color: color,
            isTitle: true,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethod.warningDialog(
                    title: "Empty Your History?",
                    subTitle: "Are you sure",
                    fct: () {
                      // viewedProdProvider.clearHistory();
                    },
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: viewedProdItemList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                child: ChangeNotifierProvider.value(
                  value: viewedProdItemList[index],
                  child: ViewedWidget(),
                ),
              );
            }),
      );
    }
  }
}
