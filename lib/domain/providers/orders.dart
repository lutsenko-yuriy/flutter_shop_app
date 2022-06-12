import 'package:flutter/material.dart';

import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}