import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screen/product_detail.dart';
import 'package:grocery_app/model/viewed_model.dart';
import 'package:grocery_app/services/globle_method.dart';
import 'package:grocery_app/services/utils.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../consts/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_providers.dart';

class ViewedWidget extends StatefulWidget {
  const ViewedWidget({Key? key}) : super(key: key);

  @override
  State<ViewedWidget> createState() => _ViewedWidgetState();
}

class _ViewedWidgetState extends State<ViewedWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final viewedProdModel = Provider.of<ViewedProdModel>(context);
    final getCurrProduct = productProvider.findProdById(viewedProdModel.productId);
    double usedPrice = getCurrProduct.isOnSale ? getCurrProduct.salePrice : getCurrProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    final Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: GestureDetector(
          onTap: () {
            // GlobalMethod.navigatTo(
            //     ctx: context, routeName: ProductDetail.routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FancyShimmerImage(
                imageUrl: getCurrProduct.imageUrl,
                boxFit: BoxFit.fill,
                width: size.width * 0.25,
                height: size.width * 0.27,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  TextWidget(
                    text: getCurrProduct.title,
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: "\$${usedPrice.toStringAsFixed(2)}",
                    color: color,
                    textSize: 18,
                    isTitle: false,
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _isInCart
                        ? null
                        : ()async {
                      final User? user= authInstance.currentUser;
                      if(user==null){
                        GlobalMethod.errorDialog(subTitle: "No user found, Please register first", context: context);
                        return;
                      }
                    await  GlobalMethod.addToCart(productId: getCurrProduct.id, quantity: 1, context: context);
                      await   cartProvider.fetchCart();
                            // cartProvider.addProductToCart(
                            //     productId: getCurrProduct.id, quantity: 1);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
