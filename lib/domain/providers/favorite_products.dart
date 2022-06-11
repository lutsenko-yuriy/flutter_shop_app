import 'package:flutter/material.dart';

class FavoriteProducts with ChangeNotifier {
  Set<String> _favoriteProductsIds = {};

  bool checkIfProductIsFavoriteById(String productId) {
    return _favoriteProductsIds.contains(productId);
  }

  bool toggleFavorite(String productId) {
    if (checkIfProductIsFavoriteById(productId)) {
      removeProductWithIdFromFavorites(productId);
    } else {
      addProductWithIdToFavorites(productId);
    }
  }

  void addProductWithIdToFavorites(String productId) {
    _favoriteProductsIds.add(productId);
    notifyListeners();
  }

  void removeProductWithIdFromFavorites(String productId) {
    _favoriteProductsIds.remove(productId);
    notifyListeners();
  }

}