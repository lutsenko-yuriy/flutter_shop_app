import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/network/base_api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;


  Future<void> signup(String email, String password) async {
    final url =
        Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${BaseApiKey.apiKey}");
    try {
      var response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true
      }));

      print(response.body);

      var object = json.decode(response.body) as Map<String, dynamic>;
      _token = object["idToken"];
      _expireDate = DateTime.now()..add(Duration(seconds: object["expiresIn"]));
      _userId = object['localId'];

    } catch (e) {
      print(e);
    }
  }
}
