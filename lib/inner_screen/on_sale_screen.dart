import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/back_widget.dart';
import 'package:grocery_app/widgets/empty_prod_screen.dart';
import 'package:grocery_app/widgets/onslae_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../model/Product_ model.dart';
import '../providers/product_providers.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = '/OnSaleScreen';
  const OnSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> productOnSale = productProvider.getOnSaleProducts;
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: "Product on Sale",
          color: color,
          isTitle: true,
          textSize: 22,
        ),
        leading: BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: productOnSale.isEmpty
          ? EmptyProductScreen(tileText: "No product on sale yet!\nStay tuned")
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productOnSale.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productOnSale[index],
                    child: OnSaleWidgets());
              }),
            ),
    );
  }
}
