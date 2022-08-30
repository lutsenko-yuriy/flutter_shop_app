import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/auth.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/domain/providers/orders.dart';
import 'package:flutter_complete_guide/ui/screens/auth_screen.dart';
import 'package:flutter_complete_guide/ui/screens/cart_screen.dart';
import 'package:flutter_complete_guide/ui/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/ui/screens/orders_screen.dart';
import 'package:flutter_complete_guide/ui/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import '/ui/screens/product_detail_screen.dart';
import '/ui/screens/products_overview_screen.dart';
import 'domain/providers/all_products.dart';
import 'domain/providers/shopping_cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProvider(
            create: (ref) {
              return AllProducts(auth: ref.read<Auth>());
            },
          ),
          ChangeNotifierProvider(
            create: (ref) => FavoriteProducts(auth: ref.read<Auth>()),
          ),
          ChangeNotifierProvider(
            create: (_) => ShoppingCart(),
          ),
          ChangeNotifierProvider(
            create: (ref) {
              return Orders(allProducts: ref.read<AllProducts>());
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepOrange,
                  ),
                  fontFamily: 'Lato'),
              home: auth.authenticated ? ProductsOverviewScreen() : AuthScreen(),
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen()
              },
            );
          },
        ));
  }
}
