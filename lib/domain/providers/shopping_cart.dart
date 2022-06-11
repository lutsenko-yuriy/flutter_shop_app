import 'package:flutter/material.dart';

class ShoppingCart with ChangeNotifier {
  Map<String, int> _productsIdsInCart = {};

  bool checkIfProductIsInCartById(String productId) {
    return _productsIdsInCart.containsKey(productId) && _productsIdsInCart[productId] > 0;
  }

  bool toggleInCart(String productId) {
    var isInCart = checkIfProductIsInCartById(productId);
    if (isInCart) {
      removeProductWithIdFromCart(productId);
    } else {
      addProductWithIdToCart(productId);
    }
    return !isInCart;
  }

  void addProductWithIdToCart(String productId) {
    _productsIdsInCart[productId] = 1;
    notifyListeners();
  }

  void setCountForProductWithId(String productId, int count) {
    _productsIdsInCart[productId] = count;
    notifyListeners();
  }

  void removeProductWithIdFromCart(String productId) {
    _productsIdsInCart.remove(productId);
    notifyListeners();
  }
}