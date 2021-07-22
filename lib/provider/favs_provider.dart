import 'package:app_store/models/cart_attr.dart';
import 'package:app_store/models/favs_attr.dart';
import 'package:flutter/cupertino.dart';

class FavsProvider with ChangeNotifier {
  Map<String, FavsAttr> _FavsItems = {};

  Map<String, FavsAttr> get getFavsItems {
    return {..._FavsItems};
  }

  void addAndRemoveFromFav(
      String productId, double price, String title, String imageUrl) {
    if (_FavsItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _FavsItems.putIfAbsent(
          productId,
          () => FavsAttr(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              iamgeUrl: imageUrl));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _FavsItems.remove(productId);
    notifyListeners();
  }

  void clearFavs() {
    _FavsItems.clear();
    notifyListeners();
  }
}
