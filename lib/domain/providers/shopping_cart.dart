import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/models/cart_position.dart';

import '../models/product.dart';

class ShoppingCart with ChangeNotifier {
  Map<String, CartPosition> _productsInCart = {};

  int get productsCount {
    return _productsInCart.values
        .fold(0, (previousValue, element) => previousValue + element.count);
  }

  int getProductCountById(String productId) {
    if (checkIfProductIsInCartById(productId)) {
      return _productsInCart[productId].count;
    } else {
      return 0;
    }
  }

  bool checkIfProductIsInCartById(String productId) {
    return _productsInCart.containsKey(productId);
  }

  void addProduct(Product product, {int count = 1}) {
    if (checkIfProductIsInCartById(product.id)) {
      _productsInCart.update(product.id, (currentPosition) {
        var newCount = currentPosition.count + count;
        return CartPosition(
            id: currentPosition.id,
            product: currentPosition.product,
            count: newCount,
            price: newCount * product.price);
      });
    } else {
      _productsInCart.putIfAbsent(
          product.id,
          () => CartPosition(
              id: DateTime.now().toString(),
              product: product,
              count: count,
              price: count * product.price));
    }
    notifyListeners();
  }

  void removeProduct(Product product, {int count = 1}) {
    if (!checkIfProductIsInCartById(product.id)) {
      return;
    }

    var newCount = _productsInCart[product.id].count - count;
    if (newCount > 0) {
      _productsInCart.update(product.id, (currentPosition) {
            var newCount = currentPosition.count + count;
            return CartPosition(
                id: currentPosition.id,
                product: currentPosition.product,
                count: newCount,
                price: newCount * product.price);
          });
    } else {
      removeProductWithIdFromCart(product.id);
    }
    notifyListeners();
  }

  void removeProductWithIdFromCart(String productId) {
    _productsInCart.remove(productId);
    notifyListeners();
  }
}
