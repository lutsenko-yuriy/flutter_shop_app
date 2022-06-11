import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/domain/providers/shopping_cart.dart';
import 'package:flutter_complete_guide/ui/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  const ProductItem(this._product, {Key key}) : super(key: key);

  void _toggleFavorite(BuildContext context) {
    context.read<FavoriteProducts>().toggleFavorite(_product.id);
  }

  void _toggleInCart(BuildContext context) {
    context.read<ShoppingCart>().toggleInCart(_product.id);
  }

  void _goToDetails(BuildContext context) {
    Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
        arguments: {ProductDetailScreen.productIdArgument: _product.id});
  }

  @override
  Widget build(BuildContext context) {
    var favorite = context
        .watch<FavoriteProducts>()
        .checkIfProductIsFavoriteById(_product.id);
    var inCart = context
        .watch<ShoppingCart>()
        .checkIfProductIsInCartById(_product.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => _goToDetails(context),
          child: Image.network(
            _product.imageUrl,
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
              _product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(inCart
                  ? Icons.shopping_cart
                  : Icons.add_shopping_cart),
              onPressed: () => _toggleInCart(context),
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
    );
  }
}
