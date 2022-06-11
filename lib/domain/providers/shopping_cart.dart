import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/models/cart_position.dart';

import '../models/product.dart';

class ShoppingCart with ChangeNotifier {
  Map<String, CartPosition> _productsInCart = {};

  bool checkIfProductIsInCartById(String productId) {
    return _productsInCart.containsKey(productId);
  }

  void addToCart(Product product, {int count = 1}) {
    if (checkIfProductIsInCartById(product.id)) {
      _productsInCart.update(product.id, (currentPosition) {
        var newCount = currentPosition.count + count;
        return CartPosition(
              id: currentPosition.id,
              productId: currentPosition.productId,
              title: currentPosition.title,
              count: newCount,
              price: newCount * product.price
          );
      });
    } else {
      _productsInCart.putIfAbsent(product.id, () =>
          CartPosition(
              id: DateTime.now().toString(),
              productId: product.id,
              title: product.title,
              count: count,
              price: count * product.price
          ));
    }
    notifyListeners();
  }

  void removeProductWithIdFromCart(String productId) {
    _productsInCart.remove(productId);
    notifyListeners();
  }
}