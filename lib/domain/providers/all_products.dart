import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../network/http_base_url.dart';
import '../../network/http_exception.dart';
import '../models/product.dart';
import 'auth.dart';

class AllProducts with ChangeNotifier {
  final Auth auth;

  AllProducts({@required this.auth});

  final _baseUrl = BaseUrl.baseUrl;

  get _baseProductUrl => "${_baseUrl}/products.json?auth=${auth.token}";
  get _userSpecificArguments => "&orderBy=\"creatorId\"&equalTo=\"${auth.userId}\"";

  Uri _buildUpdateProductUri(String productId) {
    return Uri.parse(
        "${_baseUrl}/products/${productId}.json?auth=${auth.token}");
  }

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts([bool userSpecific = false]) async {
    try {
      final response = await http.get(
        Uri.parse(_baseProductUrl + (userSpecific ? _userSpecificArguments : ""))
      );
      final responseAsObject =
          json.decode(response.body) as Map<String, dynamic>;

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
      result.add(Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          price: productData["price"]));
    });

    return result;
  }

  Product productById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<http.Response> _buildNewProductRequest(Product product) {
    if (product.id != null) {
      throw Exception("Attempted to add a new product with the existing ID");
    }

    return http.post(Uri.parse(_baseProductUrl),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': auth.userId
        }));
  }

  Future<http.Response> _buildUpdateProductRequest(Product product) {
    if (product.id == null) {
      throw Exception(
          "Attempted to update the existing product without an existing ID");
    }

    return http.patch(_buildUpdateProductUri(product.id),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));
  }

  Future<http.Response> _buildDeleteProductRequest(Product product) async {
    if (product.id == null) {
      throw Exception(
          "Attempted to update the existing product without an existing ID");
    }

    var response = await http.delete(
      _buildUpdateProductUri(product.id),
    );

    if (response.statusCode >= 400) {
      throw HttpException("Could not delete product");
    }

    return response;
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await _buildNewProductRequest(product);
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

  Future<void> replaceProduct(Product product) async {
    try {
      final index = _items.indexWhere((element) => element.id == product.id);
      if (index < 0) {
        return;
      }
      await _buildUpdateProductRequest(product);
      _items[index] = product;

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> removeProduct(Product product) async {
    final indexToRemove =
        _items.indexWhere((element) => element.id == product.id);
    var itemToRemove = _items[indexToRemove];
    _items.removeAt(indexToRemove);
    notifyListeners();

    try {
      await _buildDeleteProductRequest(product);
    } catch (exception) {
      _items.insert(indexToRemove, itemToRemove);
      notifyListeners();
      throw exception;
    }
  }
}
