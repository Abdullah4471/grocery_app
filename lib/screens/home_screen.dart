import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screen/feeds_screen.dart';
import 'package:grocery_app/inner_screen/on_sale_screen.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/feeds_items.dart';
import 'package:grocery_app/widgets/onslae_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/const.dart';
import '../model/Product_ model.dart';
import '../providers/product_providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;

    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productProvider.getProducts;
    List<ProductModel> productOnSale = productProvider.getOnSaleProducts;


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // This is the Card swiper
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImage[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: Constss.offerImage.length,
                autoplay: true,
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white,
                    activeColor: Colors.red,
                    size: 10,
                    space: 4,
                  ),
                ),
              ),
            ),
            // This is the Text button of view all
            SizedBox(
              height: 6,
            ),
            TextButton(
              onPressed: () {
                GlobalMethod.navigatTo(
                    ctx: context, routeName: OnSaleScreen.routeName);
              },
              child: TextWidget(
                text: "View all",
                color: Colors.blue,
                textSize: 18,
                isTitle: true,
              ),
            ),
            SizedBox(
              height: 6,
            ),

            // Row after the text button

            Row(
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Row(
                    children: [
                      TextWidget(
                        text: "ON SALE".toUpperCase(),
                        color: Colors.red,
                        textSize: 22,
                        isTitle: true,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        IconlyLight.discount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                // Using flexible widget to make a List view builder
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.22,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productOnSale.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: productOnSale[index],
                              child: OnSaleWidgets());
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextWidget(
                      text: "Our product",
                      color: color,
                      textSize: 22,
                      isTitle: true),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      GlobalMethod.navigatTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                      text: "Browse all",
                      textSize: 20,
                      color: Colors.blue,
                      isTitle: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: size.width / (size.height * 0.62),
                children: List.generate(
                    allProduct.length < 4 ? allProduct.length : 4, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProduct[index],
                    child: FeedsWidget(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
