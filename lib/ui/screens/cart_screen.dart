import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/cart_position.dart';
import '../../domain/providers/orders.dart';
import '../../domain/providers/shopping_cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key key}) : super(key: key);

  void _removePosition(BuildContext context, CartPosition position) {
    context.read<ShoppingCart>().removePosition(position.product);
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
                    OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  final ShoppingCart cart;

  const OrderButton({Key key, @required this.cart}) : super(key: key);

  void _submitOrder(BuildContext context, List<CartPosition> positions) {
    if (positions.isNotEmpty) {
      context.read<Orders>().addOrder(
          positions,
          positions.fold(
              0, (previousValue, element) => previousValue + element.price));
      context.read<ShoppingCart>().clearCart();

      Navigator.of(context).pop();
    }
  }

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cartIsEmpty = this.widget.cart.positions.isEmpty;
    return TextButton(
        onPressed: cartIsEmpty || _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                widget._submitOrder(context, widget.cart.positions);
                setState(() {
                  _isLoading = false;
                });
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text('ORDER NOW',
                style: TextStyle(
                  color: cartIsEmpty
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
                )));
  }
}
