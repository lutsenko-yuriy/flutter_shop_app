import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/providers/all_products.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {

  static const routeName = '/products';

  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loadedProducts = context.watch<AllProducts>().items;
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductsGrid(_loadedProducts),
    );
  }
}
