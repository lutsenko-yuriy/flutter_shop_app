import 'package:flutter/material.dart';

import 'cart_position.dart';

class Order {
  final String id;
  final double totalPrice;
  final List<CartPosition> positions;
  final DateTime orderTime;

  Order(
      {@required this.id,
      @required this.totalPrice,
      @required this.positions,
      @required this.orderTime});

  factory Order.rightNowWithDefaultPrice(List<CartPosition> positions) {
    final DateTime orderTime = DateTime.now();
    final double totalPrice = positions.fold(
        0.0, (previousValue, element) => previousValue + element.price);

    return Order(
        id: orderTime.toString(),
        totalPrice: totalPrice,
        positions: positions,
        orderTime: orderTime);
  }
}
