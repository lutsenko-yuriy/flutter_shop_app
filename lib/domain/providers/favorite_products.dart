import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../network/http_base_url.dart';

class FavoriteProducts with ChangeNotifier {
  Set<String> _favoriteProductsIds = {};

  static const _baseUrl = BaseUrl.baseUrl;
  static final _favoritesUri = Uri.parse("${_baseUrl}/favorites.json");

  Future<void> fetchAndSetFavorites() async {
    try {
      final response = await http.get(_favoritesUri);
      final responseAsObject = json.decode(response.body) as List<String>;

      _favoriteProductsIds =
          responseAsObject == null ? {} : responseAsObject.toSet();
      print(_favoriteProductsIds);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  bool checkIfProductIsFavoriteById(String productId) {
    return _favoriteProductsIds.contains(productId);
  }

  bool toggleFavorite(String productId) {
    var isFavorite = checkIfProductIsFavoriteById(productId);
    if (isFavorite) {
      removeProductWithIdFromFavorites(productId);
    } else {
      addProductWithIdToFavorites(productId);
    }
    return !isFavorite;
  }

  Future<void> addProductWithIdToFavorites(String productId) async {
    _favoriteProductsIds.add(productId);
    notifyListeners();

    try {
      await http.put(_favoritesUri, body: json.encode(_favoriteProductsIds.toList()));
    } catch (e) {
      _favoriteProductsIds.remove(productId);
      notifyListeners();
      throw e;
    }
  }

  Future<void> removeProductWithIdFromFavorites(String productId) async {
    _favoriteProductsIds.remove(productId);
    notifyListeners();

    try {
      await http.put(_favoritesUri, body: json.encode(_favoriteProductsIds.toList()));
    } catch (e) {
      _favoriteProductsIds.add(productId);
      notifyListeners();
      throw e;
    }
  }
}
