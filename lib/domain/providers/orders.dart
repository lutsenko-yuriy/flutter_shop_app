import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../network/http_base_url.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  var _isInit = false;
  List<Order> _orders = [];

  static const _baseUrl = BaseUrl.baseUrl;
  static final _ordersUri = Uri.parse("${_baseUrl}/orders.json");

  List<Order> get orders {
    // if (!_isInit) {
    //   try {
    //     var response = await http.get(_ordersUri);
    //
    //     final responseAsObject = (json.decode(response.body) as List<dynamic>)
    //         .map((e) => e.toString());
    //
    //     _orders.addAll(responseAsObjects);
    //   } catch (e) {
    //     throw e;
    //   }
    //   _isInit = true;
    // }
    return [..._orders];
  }

  Future<void> addOrder(Order order) async {
    _orders.insert(0, order);

    try {
      await http.post(_ordersUri, body: json.encode({order}));
    } catch (e) {
      _orders.remove(order);
      throw e;
    }
    notifyListeners();
  }
}
