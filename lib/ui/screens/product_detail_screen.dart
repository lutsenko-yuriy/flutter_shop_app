import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/all_products.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/domain/providers/shopping_cart.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  static const productIdArgument = 'productId';

  const ProductDetailScreen({Key key}) : super(key: key);

  void _toggleFavorite(BuildContext context, String productId) {
    context.read<FavoriteProducts>().toggleFavorite(productId);
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<ShoppingCart>().addProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    var productId = (ModalRoute.of(context).settings.arguments
        as Map<String, String>)[productIdArgument];

    final product = context.watch<AllProducts>().productById(productId);
    final favorite = context
        .watch<FavoriteProducts>()
        .checkIfProductIsFavoriteById(productId);
    final countInCart =
        context.watch<ShoppingCart>().getProductCountById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '€${product.price}',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              product.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.red : Colors.grey,
                ),
                onPressed: () => _toggleFavorite(context, productId),
              ),
              IconButton(
                icon: Icon(
                  countInCart > 0
                      ? Icons.shopping_cart
                      : Icons.add_shopping_cart,
                  color: countInCart > 0 ? Colors.amber : Colors.grey,
                ),
                onPressed: () => _addToCart(context, product),
              )
            ],
          )
        ]),
      ),
    );
  }
}
