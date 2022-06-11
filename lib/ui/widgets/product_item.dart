import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/ui/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';

class ProductItem extends StatefulWidget {
  final Product _product;

  const ProductItem(this._product, {Key key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isInCart = false;

  void _toggleFavorite(BuildContext context) {
    context.read<FavoriteProducts>().toggleFavorite(widget._product.id);
  }

  void _toggleInCart() {
    setState(() {
      _isInCart = !_isInCart;
    });
  }

  void _goToDetails() {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        arguments: {ProductDetailScreen.productIdArgument: widget._product.id});
  }

  @override
  Widget build(BuildContext context) {
    var favorite = context
        .watch<FavoriteProducts>()
        .checkIfProductIsFavoriteById(widget._product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: _goToDetails,
          child: Image.network(
            widget._product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () => _toggleFavorite(context),
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
