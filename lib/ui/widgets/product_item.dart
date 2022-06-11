import 'package:flutter/material.dart';

import '../../domain/product.dart';

class ProductItem extends StatefulWidget {
  final Product _product;

  const ProductItem(this._product, {Key key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isFavorite = false;
  bool _isInCart = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleInCart() {
    setState(() {
      _isInCart = !_isInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          widget._product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: _toggleFavorite,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              widget._product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(_isInCart
                  ? Icons.remove_shopping_cart
                  : Icons.add_shopping_cart),
              onPressed: _toggleInCart,
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
    );
  }
}
