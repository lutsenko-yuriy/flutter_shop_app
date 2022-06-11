import 'package:flutter/material.dart';

import '../../domain/models/product.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> _products;

  const ProductsGrid(this._products, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) => ProductItem(_products[index]));
  }
}
