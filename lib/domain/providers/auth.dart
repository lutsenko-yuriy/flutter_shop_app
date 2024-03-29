import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/network/base_api_key.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../network/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  Timer _authTimer;

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

  Future<void> signout() async {
    _token = null;
    _expireDate = null;
    _userId = null;

    if (_authTimer != null && !_authTimer.isActive) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    print("Logged out");

    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final data =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;

    final expireDate = DateTime.parse(data['expiryDate']);

    if (DateTime.now().isAfter(expireDate)) {
      return false;
    }

    _token = data['token'];
    _userId = data['userId'];
    _expireDate = expireDate;

    notifyListeners();
    _authTimer = Timer(
        Duration(seconds: expireDate.difference(DateTime.now()).inSeconds),
        signout);
    return true;
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
      _userId = responseBody['localId'];
      var duration = Duration(seconds: int.parse(responseBody["expiresIn"]));
      _expireDate = DateTime.now().add(duration);

      _autoLogout(duration);
      notifyListeners();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate.toIso8601String()
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void _autoLogout(Duration duration) {
    if (_authTimer != null && !_authTimer.isActive) {
      _authTimer.cancel();
    }

    _authTimer = Timer(duration, signout);
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

  String get userId => _userId;
}
