import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_app/inner_screen/product_detail.dart';
import 'package:grocery_app/model/cart_model.dart';
import 'package:grocery_app/providers/product_providers.dart';
import 'package:grocery_app/widgets/heart_btn.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class CartWidget extends StatefulWidget {
  final int q;
  const CartWidget({Key? key, required this.q}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final TextEditingController _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);

    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FancyShimmerImage(
                        imageUrl:
                            getCurrentProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text:getCurrentProduct.title,
                            color: color,
                            textSize: 18,
                            isTitle: true,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: size.width * .3,
                            child: Row(
                              children: [
                                _quantityController(
                                  ftx: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuantityByOne(cartModel.productId);

                                      setState(() {
                                        print("click");
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  icon: CupertinoIcons.minus,
                                  color: Colors.red,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: TextField(
                                    controller: _quantityTextController,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9]'))
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _quantityTextController.text = '1';
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                _quantityController(
                                  ftx: () {
                                    setState(() {
                                      cartProvider.increaseQuantityByOne(cartModel.productId);
                                      print("click");
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  icon: CupertinoIcons.plus,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              cartProvider.removeOneItem( cartId:  cartModel.id,
                              productId:  cartModel.productId,
                              quantity:  cartModel.quantity);
                            },
                            child: Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          HeartBTN(productId: getCurrentProduct.id,isInWishlist: _isInWishlist,),
                          SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text: "\$${(usedPrice* int.parse(_quantityTextController.text)).toStringAsFixed(2)}",
                            color: color,
                            textSize: 18,
                            maxLine: 1,
                            isTitle: true,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required VoidCallback ftx,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ftx();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
