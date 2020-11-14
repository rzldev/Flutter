import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _tokenId;
  DateTime _expiryDate;
  String _userId;

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
}
