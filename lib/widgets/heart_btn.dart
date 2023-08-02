import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../consts/firebase_const.dart';
import '../providers/product_providers.dart';
import '../providers/wishlist_provider.dart';
import '../services/globle_method.dart';
import '../services/utils.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({
    Key? key,
    required this.productId,
    this.isInWishlist = false,
  }) : super(key: key);

  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;

    Widget iconWidget = Icon(
      widget.isInWishlist != null && widget.isInWishlist == true
          ? IconlyBold.heart
          : IconlyLight.heart,
      size: 22,
      color: widget.isInWishlist != null && widget.isInWishlist == true
          ? Colors.red
          : color,
    );

    if (loading) {
      iconWidget = Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 2.0,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        try {
          final User? user = authInstance.currentUser;
          setState(() {
            loading = true;
          });

          if (user == null) {
            GlobalMethod.errorDialog(
              subTitle: 'No user found, Please login first',
              context: context,
            );
            return;
          }

          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethod.addToWishlist(
              productId: widget.productId,
              context: context,
            );
          } else {
            await wishlistProvider.removeOneItem(
              wishlistId: wishlistProvider.getWishlistItems[getCurrProduct.id]!.id,
              productId: widget.productId,
            );
          }

          await wishlistProvider.fetchWishlist();
        } catch (error) {
          GlobalMethod.errorDialog(subTitle: '$error', context: context);
        } finally {
          setState(() {
            loading = false;
          });
        }
      },
      child: iconWidget,
    );
  }
}
