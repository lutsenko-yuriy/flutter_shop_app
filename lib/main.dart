import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/ui/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
          ),
          fontFamily: 'Lato'
      ),
      routes: {
        '/': (ctx) => ProductsOverviewScreen(),
      },
    );
  }
}
