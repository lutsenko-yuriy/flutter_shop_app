import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/filter_options.dart';
import '../../domain/models/product.dart';
import '../../domain/providers/all_products.dart';
import '../../domain/providers/favorite_products.dart';
import '../../domain/providers/shopping_cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'cart_screen.dart';
import 'orders_drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products';

  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var selectedFilterOption = FilterOptions.all;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.wait([
      context.read<AllProducts>().fetchAndSetProducts(),
      context.read<FavoriteProducts>().fetchAndSetFavorites()
    ]).then((value) => {
          setState(() {
            _isLoading = false;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadedProducts = context.watch<AllProducts>().items;
    final favoriteProducts = context.watch<FavoriteProducts>();

    List<Product> productsToDisplay;
    switch (selectedFilterOption) {
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
      drawer: OrdersDrawer(),
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
          ),
          Consumer<ShoppingCart>(
              builder: (_, value, child) {
                return Badge(
                    child: child, value: value.productsCount.toString());
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widgetToDisplay,
    );
  }
}
