import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/orders.dart';
import '../widgets/order_item.dart';
import 'orders_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        drawer: OrdersDrawer(),
        body: FutureBuilder(
          future: context.read<Orders>().fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.hasError) {
              return Center(
                child: Text("Failed to load orders"),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                var orders = orderData.orders;
                return orders.isNotEmpty
                    ? ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return OrderItem(orders[index]);
                        })
                    : Center(
                        child: Text('No orders yet!'),
                      );
              });
            }
          },
        ));
  }
}
