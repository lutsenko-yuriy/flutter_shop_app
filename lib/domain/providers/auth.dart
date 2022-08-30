import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/network/base_api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../network/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  String _urlTemplate = "https://identitytoolkit.googleapis.com/v1/accounts:";
  String _urlParams = "?key=${BaseApiKey.apiKey}";

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(_urlTemplate + "signUp" + _urlParams);
    await _authenticate(url, email, password);
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.parse(_urlTemplate + "signInWithPassword" + _urlParams);
    await _authenticate(url, email, password);
  }

  Future<void> _authenticate(Uri url, String email, String password) async {
    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      print(response.body);

      var responseBody = json.decode(response.body) as Map<String, dynamic>;

      if (responseBody["error"] != null) {
        throw HttpException(responseBody["error"]["message"]);
      }

      _token = responseBody["idToken"];
      _expireDate = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody["expiresIn"])));
      _userId = responseBody['localId'];

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  bool get authenticated {
    return _token != null &&
        _userId != null &&
        _expireDate != null &&
        _expireDate.isAfter(DateTime.now());
  }

  String get token {
    return authenticated ? _token : null;
  }
}
