import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/all_products.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';
import '../widgets/user_product_item.dart';
import 'orders_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/my-products';

  const UserProductsScreen({Key key}) : super(key: key);

  void _onEditingRequested(Product product) {
    print('The product ${product.title} is about to get edited');
  }

  void _onDeleteRequested(Product product) {
    print('The product ${product.title} is about to get deleted');
  }

  void _onNewProductRequested() {}

  @override
  Widget build(BuildContext context) {
    final products = context.watch<AllProducts>().items;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(onPressed: _onNewProductRequested, icon: Icon(Icons.add))
        ],
      ),
      drawer: OrdersDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(
                      products[index],
                      onEditingRequested: _onEditingRequested,
                      onDeleteRequested: _onDeleteRequested,
                    ),
                    Divider()
                  ],
                )),
      ),
    );
  }
}
