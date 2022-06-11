import 'package:flutter/foundation.dart';

class CartPosition {
  final String id;
  final String productId;
  final String title;
  final int count;
  final double price;

  CartPosition(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.count,
      @required this.price});
}
