import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/models/cart_position.dart';

import '../models/product.dart';

class ShoppingCart with ChangeNotifier {
  Map<String, CartPosition> _productsInCart = {};

  int get productsCount {
    return _productsInCart.values
        .fold(0, (previousValue, element) => previousValue + element.count);
  }

  int get positionsCount {
    return _productsInCart.length;
  }

  List<CartPosition> get positions {
    return _productsInCart.values.toList();
  }

  double get totalPrice {
    return _productsInCart.values
        .fold(0.0, (previousValue, element) => previousValue + element.price);
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
        return CartPosition.withDefaultPrice(
            id: currentPosition.id,
            product: currentPosition.product,
            count: newCount);
      });
    } else {
      _productsInCart.putIfAbsent(
          product.id,
          () => CartPosition.withDefaultPrice(
              id: DateTime.now().toString(), product: product, count: count));
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
        return CartPosition.withDefaultPrice(
            id: currentPosition.id,
            product: currentPosition.product,
            count: newCount);
      });
    } else {
      removePosition(product);
    }
    notifyListeners();
  }

  void removePosition(Product product) {
    _productsInCart.remove(product.id);
    notifyListeners();
  }
}
