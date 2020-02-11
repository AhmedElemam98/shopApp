import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth{
    return _token!=null;
  }

  String get token{
    if(_token!=null&&_expiryDate!=null&&_expiryDate.isAfter(DateTime.now())){
      return _token;
    }
    else
    return null;
  }

  String get userId{
    return _userId;
  }


  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCpV-Hqko6-txSNr1aX93-TdOfjZ-ae9Tc";

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData =
          json.decode(response.body.toString()) as Map<String, dynamic>;

      // print(responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
       _token = responseData['idToken'];
       _userId = responseData['localId'];
       _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }
}
