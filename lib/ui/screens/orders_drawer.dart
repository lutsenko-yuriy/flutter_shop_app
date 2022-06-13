import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/ui/screens/orders_screen.dart';
import 'package:flutter_complete_guide/ui/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/ui/screens/user_products_screen.dart';

class OrdersDrawer extends StatelessWidget {
  const OrdersDrawer({Key key}) : super(key: key);

  void _openProducts(BuildContext context) {
    Navigator.of(context)
        .pushReplacementNamed(ProductsOverviewScreen.routeName);
  }

  void _openOrders(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }

  void _openUserProducts(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary,
              child: Text('My Menu',
                  style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 32,
                      color: Colors.white)),
            ),
            Divider(),
            ListTile(
              style: ListTileStyle.drawer,
              leading: Icon(Icons.shopping_cart),
              title: Text('Products'),
              onTap: () => _openProducts(context),
            ),
            Divider(),
            ListTile(
              style: ListTileStyle.drawer,
              leading: Icon(Icons.credit_card),
              title: Text('My Orders'),
              onTap: () => _openOrders(context),
            ),
            Divider(),
            ListTile(
              style: ListTileStyle.drawer,
              leading: Icon(Icons.shopping_bag),
              title: Text('My Products'),
              onTap: () => _openUserProducts(context),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
