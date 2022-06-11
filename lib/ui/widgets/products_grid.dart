import 'package:flutter/material.dart';

import '../../domain/models/product.dart';
import 'product_item.dart';

class ProductsGrid extends StatefulWidget {
  final List<Product> _products;

  const ProductsGrid(this._products, {Key key}) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  Widget build(BuildContext context) {
    var products = widget._products;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) => ProductItem(products[index]));
  }
}
