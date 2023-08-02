import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screen/product_detail.dart';
import 'package:grocery_app/providers/viewed_prod_provider.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/price_widget.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../model/Product_ model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/globle_method.dart';
import '../services/utils.dart';

class OnSaleWidgets extends StatefulWidget {
  const OnSaleWidgets({Key? key}) : super(key: key);

  @override
  State<OnSaleWidgets> createState() => _OnSaleWidgetsState();
}

class _OnSaleWidgetsState extends State<OnSaleWidgets> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    bool _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);


    bool _isInWishlist = wishlistProvider.getWishlistItems.containsKey(productModel.id);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.9),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProdProvider.addProductToHistory(productId: productModel.id);

            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      width: size.width * 0.22,
                      height: size.width * 0.22,
                      boxFit: BoxFit.fill,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? "1Piece" : "1KG",
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            GestureDetector(

                              onTap: _isInCart
                                  ? null
                                  : () async {
                                final User? user =
                                    authInstance.currentUser;

                                if (user == null) {
                                  GlobalMethod.errorDialog(
                                      subTitle:
                                      'No user found, Please login first',
                                      context: context);
                                  return;
                                }
                                await GlobalMethod.addToCart(
                                    productId: productModel.id,
                                    quantity: 1,
                                    context: context);
                                await cartProvider.fetchCart();
                                // cartProvider.addProductsToCart(
                                //     productId: productModel.id,
                                //     quantity: 1);
                              },
                              child: Icon(
                               _isInCart?IconlyBold.bag2: IconlyLight.bag,
                                size: 22,
                                color: _isInCart?Colors.green:color,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            HeartBTN(productId: productModel.id,isInWishlist: _isInWishlist,),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: "1",
                  isOnSale: true,
                ),
                SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: productModel.title,
                  color: color,
                  textSize: 16,
                  isTitle: true,
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
