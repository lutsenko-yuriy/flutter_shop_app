import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/order.dart';

class OrderItem extends StatefulWidget {
  final Order _order;

  const OrderItem(this._order, {Key key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;

  void _toggleExpand() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('€${widget._order.totalPrice}'),
              subtitle: Text(DateFormat('dd MMMM yyyy HH:mm')
                  .format(widget._order.orderTime)),
              trailing: IconButton(
                icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: _toggleExpand,
              ),
            )
          ],
        ));
  }
}
