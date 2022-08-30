import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../network/http_base_url.dart';
import 'auth.dart';

class FavoriteProducts with ChangeNotifier {
  final Auth auth;

  FavoriteProducts({@required this.auth});

  Set<String> _favoriteProductsIds = {};

  final _baseUrl = BaseUrl.baseUrl;

  get _favoritesUri =>
      Uri.parse("${_baseUrl}/user/${auth.userId}/favorites.json?auth=${auth.token}");

  Future<void> fetchAndSetFavorites() async {
    try {
      final response = await http.get(_favoritesUri);

      if (response.body == null || response.body == "null") {
        return;
      }

      final responseAsObject = (json.decode(response.body) as List<dynamic>)
          .map((e) => e.toString());

      _favoriteProductsIds =
          responseAsObject == null ? {} : responseAsObject.toSet();
      print("Favorites products are : ${_favoriteProductsIds}");

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
      await http.put(_favoritesUri,
          body: json.encode(_favoriteProductsIds.toList()));
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
      await http.put(_favoritesUri,
          body: json.encode(_favoriteProductsIds.toList()));
    } catch (e) {
      _favoriteProductsIds.add(productId);
      notifyListeners();
      throw e;
    }
  }
}
