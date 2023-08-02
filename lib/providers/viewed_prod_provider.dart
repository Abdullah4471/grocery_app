import 'package:flutter/cupertino.dart';

import '../model/viewed_model.dart';


class ViewedProdProvider with ChangeNotifier {
  Map<String, ViewedProdModel> _viewedProdListItems = {};
  Map<String, ViewedProdModel> get getViewedProdListItems {
    return _viewedProdListItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedProdListItems.putIfAbsent(
        productId,
            () => ViewedProdModel(
            id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _viewedProdListItems.clear();
    notifyListeners();
  }
}
