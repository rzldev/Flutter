import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _tokenId;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_tokenId != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _userId != null) {
      return _tokenId;
    }

    return null;
  }

  String get userId {
    if (_tokenId != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _userId != null) {
      return _userId;
    }

    return null;
  }

  Future _authenticate({
    @required String email,
    @required String password,
    @required String urlSegment,
  }) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=${DotEnv().env['API_KEY']}';

    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    try {
      final response = await http.post(url, body: json.encode(requestBody));

      final responseData = await json.decode(response.body);

      if (responseData['error'] != null) {
        throw (HttpException(message: responseData['error']['message']));
      }

      _tokenId = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _userId = responseData['localId'];

      autoLogout();
      notifyListeners();

      final userData = json.encode({
        'tokenId': _tokenId,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });

      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future signUp({@required String email, @required String password}) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future login({
    @required String email,
    @required String password,
  }) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  Future logout() async {
    _tokenId = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.remove('userData');
    sharedPreferences.clear();
  }

  Future autoLogout() async {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> autoLogin() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey('userData')) {
      return false;
    }

    final extractedUserData = json
        .decode(sharedPreferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _tokenId = extractedUserData['tokenId'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    autoLogout();

    return true;
  }
}
