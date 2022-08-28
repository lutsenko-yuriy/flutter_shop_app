import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../network/http_base_url.dart';
import '../models/cart_position.dart';
import '../models/order.dart';
import 'all_products.dart';

class Orders with ChangeNotifier {
  final AllProducts allProducts;

  Orders({@required this.allProducts});

  List<Order> _orders = [];

  static const _baseUrl = BaseUrl.baseUrl;
  static final _ordersUri = Uri.parse("${_baseUrl}/orders.json");

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(_ordersUri);
      final responseAsObject =
          json.decode(response.body) as Map<String, dynamic>;

      if (responseAsObject == null) {
        return;
      }

      print(responseAsObject);
      _orders = _responseAsOrders(responseAsObject);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Order> _responseAsOrders(Map<String, dynamic> response) {
    List<Order> result = [];

    response.forEach((orderId, orderData) {
      result.add(Order(
        id: orderId,
        orderTime: DateTime.parse(orderData["dateTime"]),
        positions: (orderData["positions"] as List<dynamic>).map((position) =>
            CartPosition(
                id: position["id"],
                product: allProducts.productById(position["productId"]),
                count: position["quantity"],
                price: position["price"])).toList(),
        totalPrice: orderData["amount"],
      ));
    });

    return result;
  }

  Future<void> addOrder(List<CartPosition> positions, double total) async {
    final timestamp = DateTime.now();
    try {
      final response = await http.post(_ordersUri,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'positions': positions
                .map((position) => {
                      'id': position.id,
                      'productId': position.product.id,
                      'quantity': position.count,
                      'price': position.price
                    })
                .toList()
          }));

      _orders.insert(
          0,
          Order(
              id: json.decode(response.body)['name'],
              totalPrice: total,
              positions: positions,
              orderTime: timestamp));
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
