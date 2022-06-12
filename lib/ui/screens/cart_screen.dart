import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/cart_position.dart';
import '../../domain/models/order.dart';
import '../../domain/providers/orders.dart';
import '../../domain/providers/shopping_cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key key}) : super(key: key);

  void _removePosition(BuildContext context, CartPosition position) {
    context.read<ShoppingCart>().removePosition(position.product);
  }

  void _submitOrder(BuildContext context, List<CartPosition> positions) {
    if (positions.isNotEmpty) {
      context
          .read<Orders>()
          .addOrder(Order.rightNowWithDefaultPrice(positions));
      context.read<ShoppingCart>().clearCart();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShoppingCart cart = context.watch<ShoppingCart>();
    var positions = cart.positions;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text('€${cart.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge
                                  .color)),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                        onPressed: () {
                          _submitOrder(context, positions);
                        },
                        child: Text('ORDER NOW',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )))
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
                    itemCount: cart.positionsCount,
                    itemBuilder: (context, index) {
                      return CartItem(
                        positions[index],
                        (position) => _removePosition(context, position),
                      );
                    }))
          ],
        ));
  }
}
