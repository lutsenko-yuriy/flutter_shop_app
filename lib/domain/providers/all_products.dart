import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class AllProducts with ChangeNotifier {
  static final productsUri = Uri.parse("https://flutter-shop-fec37-default-rtdb.europe-west1.firebasedatabase.app/products.json");
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(productsUri);
      final responseAsObject = json.decode(response.body) as Map<String, dynamic>;

      print(responseAsObject);
      _items = _responseAsProducts(responseAsObject);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> _responseAsProducts(Map<String, dynamic> response) {
    List<Product> result = [];

    response.forEach((productId, productData) {
      result.add(
        Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          price: productData["price"]
        )
      );
    });

    return result;
  }

  Product productById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> addOrReplaceProduct(Product product) async {
    try {
      final response = await http
              .post(
                  productsUri ,
                  body: json.encode({
                    'title': product.title,
                    'description': product.description,
                    'price': product.price,
                    'imageUrl': product.imageUrl,
                  }));
      final productToAdd = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(productToAdd);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }
}
