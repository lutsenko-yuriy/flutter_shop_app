import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';
import '../../domain/providers/all_products.dart';
import '../../domain/providers/favorite_products.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';
import 'orders_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/my-products';

  const UserProductsScreen({Key key}) : super(key: key);

  void _onEditingRequested(BuildContext context, Product product) {
    Navigator.of(context)
        .pushNamed(EditProductScreen.routeName, arguments: product.id);
  }

  void _onDeleteRequested(BuildContext context, Product product) async {
    try {
      await context.read<AllProducts>().removeProduct(product);
    } catch (exception) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Deleting failed')));
    }
  }

  void _onNewProductRequested(BuildContext context) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName);
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Future.wait([
      context.read<AllProducts>().fetchAndSetProducts(true),
      context.read<FavoriteProducts>().fetchAndSetFavorites()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
              onPressed: () => _onNewProductRequested(context),
              icon: Icon(Icons.add))
        ],
      ),
      drawer: OrdersDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<AllProducts>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, index) => Column(
                                  children: [
                                    UserProductItem(
                                      productsData.items[index],
                                      onEditingRequested: (product) =>
                                          _onEditingRequested(context, product),
                                      onDeleteRequested: (product) =>
                                          _onDeleteRequested(context, product),
                                    ),
                                    Divider()
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
