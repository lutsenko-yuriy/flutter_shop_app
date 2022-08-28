import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/orders.dart';
import '../widgets/order_item.dart';
import 'orders_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _isLoading = true;
      });
      await context.read<Orders>().fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orders = context.watch<Orders>().orders;
    var body = orders.isNotEmpty
        ? ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderItem(orders[index]);
            })
        : Center(
            child: Text('No orders yet!'),
          );
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: OrdersDrawer(),
      body: _isLoading ? CircularProgressIndicator() : body,
    );
  }
}
