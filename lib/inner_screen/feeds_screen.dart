import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:grocery_app/model/Product_%20model.dart';
import 'package:grocery_app/providers/product_providers.dart';
import 'package:provider/provider.dart';
import '../services/utils.dart';
import '../widgets/empty_prod_screen.dart';
import '../widgets/feeds_items.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/FeedsScreen';
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController _searchTextController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  List<ProductModel> listProdcutSearch = [];


  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final Color color = Utils(context).color;
    final Size size = utils.getScreenSize;

    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProduct = productsProvider.getProducts;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextWidget(
          text: "All Product",
          color: color,
          isTitle: true,
          textSize: 22,
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: color,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  controller: _searchTextController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    setState(() {
                      listProdcutSearch =
                          productsProvider.searchQuery(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "What's in your mind!",
                    prefixIcon: Icon(IconlyLight.search),
                    suffix: IconButton(
                      onPressed: () {
                        _searchTextController.clear();
                        _searchFocusNode.unfocus();
                      },
                      icon: Icon(
                        Icons.close,
                        color: _searchFocusNode.hasFocus ? Colors.red : color,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            _searchTextController.text.isNotEmpty &&
                listProdcutSearch.isEmpty
                ? const EmptyProductScreen(
                tileText: 'No products found, please try another keyword')
                : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.59),
              children: List.generate(
                  _searchTextController.text.isNotEmpty
                      ? listProdcutSearch.length
                      : allProduct.length, (index) {
                return ChangeNotifierProvider.value(
                  value: _searchTextController.text.isNotEmpty
                      ? listProdcutSearch[index]
                      : allProduct[index],
                  child: const FeedsWidget(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
