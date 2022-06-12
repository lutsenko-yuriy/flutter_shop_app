import 'package:flutter/material.dart';

import '../../domain/models/cart_position.dart';
import '../screens/product_detail_screen.dart';

class CartItem extends StatelessWidget {
  final CartPosition _position;

  final Function _removePosition;

  const CartItem(this._position, this._removePosition, {Key key})
      : super(key: key);

  void _openProductDetails(BuildContext context) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        arguments: {ProductDetailScreen.productIdArgument: _position.product.id});
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_position.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        _removePosition(_position);
      },
      child: GestureDetector(
        onTap: () {
          _openProductDetails(context);
        },
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.network(_position.product.imageUrl,
                        fit: BoxFit.cover)),
                title: Row(
                  children: [
                    Text(_position.product.title),
                    SizedBox(width: 5),
                    if (_position.count > 1)
                      Text(
                        'x${_position.count}',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: Colors.grey),
                      )
                  ],
                ),
                subtitle: Text('Total: €${_position.price.toStringAsFixed(2)}'),
              ),
            )),
      ),
    );
  }
}
