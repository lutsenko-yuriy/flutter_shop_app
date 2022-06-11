import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/domain/providers/shopping_cart.dart';
import 'package:provider/provider.dart';

import '../../domain/models/filter_options.dart';
import '../../domain/models/product.dart';
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
    final shoppingCart = context.watch<ShoppingCart>();

    List<Product> productsToDisplay;
    switch (selectedFilterOption) {
      case FilterOptions.shoppingCart:
        productsToDisplay = loadedProducts
            .where((product) =>
                shoppingCart.checkIfProductIsInCartById(product.id))
            .toList();
        break;
      case FilterOptions.favorites:
        productsToDisplay = loadedProducts
            .where((product) =>
                favoriteProducts.checkIfProductIsFavoriteById(product.id))
            .toList();
        break;
      case FilterOptions.all:
        productsToDisplay = loadedProducts;
        break;
    }

    final Widget widgetToDisplay = productsToDisplay.isNotEmpty
        ? ProductsGrid(productsToDisplay)
        : Center(
            child: Text('The list is empty'),
          );

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
              PopupMenuItem(
                  child: Text('Only in the cart'),
                  value: FilterOptions.shoppingCart),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.all),
            ],
          )
        ],
      ),
      body: widgetToDisplay,
    );
  }
}
