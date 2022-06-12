import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orders = context.watch<Orders>().orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderItem(orders[index]);
          }
      ),
    );
  }
}
