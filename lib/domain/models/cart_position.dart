import 'package:flutter/foundation.dart';

import 'product.dart';

class CartPosition {
  final String id;
  final Product product;
  final int count;
  final double price;

  CartPosition(
      {@required this.id,
      @required this.product,
      @required this.count,
      @required this.price});
}
