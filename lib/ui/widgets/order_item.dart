import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/ui/screens/product_detail_screen.dart';
import 'package:intl/intl.dart';

import '../../domain/models/order.dart';
import '../../domain/models/product.dart';

class OrderItem extends StatefulWidget {
  final Order _order;

  const OrderItem(this._order, {Key key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _openProductDetails(BuildContext context, Product product) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        arguments: {ProductDetailScreen.productIdArgument: product.id});
  }

  @override
  Widget build(BuildContext context) {
    var duration = Duration(milliseconds: 300);
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: duration,
      child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text('€${widget._order.totalPrice}'),
                subtitle: Text(DateFormat('dd MMMM yyyy HH:mm')
                    .format(widget._order.orderTime)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: _toggleExpand,
                ),
              ),
              AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeIn,
                  child: Divider(
                    height: _expanded ? 1 : 0,
                  )),
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeIn,
                height: _expanded ? 100 : 0,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget._order.positions.map((position) {
                    return GestureDetector(
                      onTap: () =>
                          _openProductDetails(context, position.product),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.network(
                          position.product.imageUrl,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          )),
    );
  }
}
