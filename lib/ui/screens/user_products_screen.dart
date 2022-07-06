import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/all_products.dart';
import 'package:flutter_complete_guide/ui/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';
import '../widgets/user_product_item.dart';
import 'orders_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/my-products';

  const UserProductsScreen({Key key}) : super(key: key);

  void _onEditingRequested(BuildContext context, Product product) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: product.id);
  }

  void _onDeleteRequested(BuildContext context, Product product) async {
    try {
      await context.read<AllProducts>().removeProduct(product);
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting failed')));
    }
  }

  void _onNewProductRequested(BuildContext context) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName);
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<AllProducts>().fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<AllProducts>().items;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(onPressed: () => _onNewProductRequested(context), icon: Icon(Icons.add))
        ],
      ),
      drawer: OrdersDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) => Column(
                    children: [
                      UserProductItem(
                        products[index],
                        onEditingRequested: (product) => _onEditingRequested(context, product),
                        onDeleteRequested: (product) => _onDeleteRequested(context, product),
                      ),
                      Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
