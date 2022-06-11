import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/all_products.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  static const productIdArgument = 'productId';

  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productId = (ModalRoute.of(context).settings.arguments
        as Map<String, String>)[productIdArgument];

    final product = context
        .watch<AllProducts>()
        .items
        .firstWhere((element) => element.id == productId);
    final favorite = context
        .watch<FavoriteProducts>()
        .checkIfProductIsFavoriteById(productId);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${product.title}. ${favorite ? "A" : "Not a"} favorite one.'),
      ),
    );
  }
}
