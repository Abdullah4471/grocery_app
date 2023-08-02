import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/inner_screen/product_detail.dart';
import 'package:grocery_app/model/whishlist_model.dart';
import 'package:grocery_app/providers/product_providers.dart';
import 'package:grocery_app/providers/wishlist_provider.dart';
import 'package:grocery_app/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';

class WishListWidget extends StatelessWidget {
  const WishListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;
    final productProvider =Provider.of<ProductsProvider>(context);
    final wishlistProvider =Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct = productProvider.findProdById(wishlistModel.productId);
    bool _isInWishlist = wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;


    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 8,),
                  height: size.width * .25,

                  child: FancyShimmerImage(
                    imageUrl:
                        getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              IconlyLight.bag2,
                              color: color,
                            ),
                          ),
                          HeartBTN(productId:getCurrentProduct.id,isInWishlist: _isInWishlist)
                            ,
                        ],
                      ),
                    ),
                    TextWidget(
                      text: getCurrentProduct.title,
                      textSize: 18,
                      isTitle: true,
                      color: color,
                    ),
                    SizedBox(height: 5,),
                    TextWidget(
                      text: "\$${usedPrice.toStringAsFixed(2)}",
                      color: color,
                      textSize: 18,
                      isTitle: true,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
