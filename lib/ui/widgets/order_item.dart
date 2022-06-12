import 'package:flutter/material.dart';

import '../../domain/models/order.dart';

class OrderItem extends StatelessWidget {
  final Order _order;
  
  const OrderItem(this._order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('€${_order.totalPrice}');
  }
}
