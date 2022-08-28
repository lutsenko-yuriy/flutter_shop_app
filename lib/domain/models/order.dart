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

}
