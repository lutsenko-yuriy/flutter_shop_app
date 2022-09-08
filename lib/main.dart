import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/domain/providers/auth.dart';
import 'package:flutter_complete_guide/domain/providers/favorite_products.dart';
import 'package:flutter_complete_guide/domain/providers/orders.dart';
import 'package:flutter_complete_guide/helpers/custom_transition.dart';
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
              return Orders(
                  auth: ref.read<Auth>(), allProducts: ref.read<AllProducts>());
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepOrange,
                  ),
                  fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android : CustomPageTransitionsBuilder(),
                    TargetPlatform.iOS : CustomPageTransitionsBuilder(),
                  }
                )
              ),
              home: auth.authenticated
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authSnapshot) {
                  return authSnapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : AuthScreen();
                },
              ),
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
