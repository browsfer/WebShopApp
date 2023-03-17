import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late String _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> authenticateUser(
      String? email, String? password, String urlSegment) async {
    try {
      final response = await http.post(
          Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCsLcgWaaxjwsJu8R7wOtTSbqU6JQ-E7DU',
          ),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> signUp(String? email, String? password) async {
    return authenticateUser(email, password, 'signUp');
  }

  Future<void> signIn(String? email, String? password) async {
    return authenticateUser(email, password, "signInWithPassword");
  }
}
