import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
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
        ChangeNotifierProvider(create: (_) => AllProducts(),),
        ChangeNotifierProvider(create: (_) => FavoriteProducts(),),
        ChangeNotifierProvider(create: (_) => ShoppingCart(),),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepOrange,
            ),
            fontFamily: 'Lato'
        ),
        routes: {
          '/' : (ctx) => ProductsOverviewScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen()
        },
      ),
    );
  }
}
