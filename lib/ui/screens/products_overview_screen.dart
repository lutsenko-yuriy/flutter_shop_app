import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:provider/provider.dart';

import '../../domain/models/filter_options.dart';
import '../../domain/providers/all_products.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products';

  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var selectedFilterOption = FilterOptions.all;

  @override
  Widget build(BuildContext context) {
    final loadedProducts = context.watch<AllProducts>().items;
    final favoriteProducts = context.watch<FavoriteProducts>();

    final productsToDisplay = selectedFilterOption == FilterOptions.all
        ? loadedProducts
        : loadedProducts.where((product) =>
            favoriteProducts.checkIfProductIsFavoriteById(product.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                selectedFilterOption = selectedValue;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.favorites),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.all),
            ],
          )
        ],
      ),
      body: ProductsGrid(productsToDisplay),
    );
  }
}
