import 'package:flutter/material.dart';

import '../../domain/models/product.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;

  final Function onEditingRequested;
  final Function onDeleteRequested;

  const UserProductItem(this._product,
      {Key key, this.onEditingRequested, this.onDeleteRequested})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_product.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(_product.imageUrl)),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => onEditingRequested(_product),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () => onDeleteRequested(_product),
            ),
          ],
        ),
      ),
    );
  }
}
