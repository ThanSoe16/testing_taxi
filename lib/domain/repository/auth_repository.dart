import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/domain/exception/exception.handler.dart';
import 'package:testing/domain/models/response_modal.dart';
import 'package:testing/domain/models/login_model.dart';
import 'package:testing/env.dart';
import 'package:testing/utilities/constants.dart';

class AuthRepository with ChangeNotifier {
  String? _token;
  ResponseModal? _error;

  Future<bool> isAuthenticated() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(Constants.prefsToken);
    if (token != null ) {
      return true;
    }
    return false;
  }

  // Future<bool> tryAutoLogin() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   if (!pref.containsKey(Constants.prefsToken)) {
  //     return false;
  //   }
  //   _token = pref.getString(Constants.prefsToken);
  //   return true;
  // }

  Map<String, String> _createAuthHeader() {
    return {
      'Content-Type': "application/json",
      'module': 'driver',
      'platform': 'android',
      'client-version': '1.1.10',
      'language': 'en',
      'device-id': 'dev1234567890',
      'operating-system-version': 'lollipop 14.3.2',
      'secure-key': 'EpdM82lwqxphrAFo'
    };
  }

  Future<Map<String, String>> getAuthHeader() async {
    return _createAuthHeader();
  }

  Future<void> login(LoginModel loginModel) async {
    Uri uri = Uri.https(Env.uri, "/authentication/login");
    return post(uri,
            headers: await getAuthHeader(),
            body: json.encode(loginModel.toJson()))
        .then((value) {
      _error = ResponseModal.fromJson(
          json.decode(utf8.decode(value.bodyBytes)));
      if (_error?.errormodal?.code == 0) {
        ExceptionHandler.httpExceptionHandle(
            value.statusCode, "Successful Login");
        _saveToDevice(_error?.tokenModal?.new_access_token);
      } else {
        ExceptionHandler.httpExceptionHandle(
            401, "Invalid credential");
      }
      notifyListeners();
    });
  }

  void _saveToDevice(token) {
    _token = token;
    SharedPreferences.getInstance().then((pref) {
      pref.setString(Constants.prefsToken, token);
    });
  }

  void logout(){
    _token = null;
    _removeFromDevice();
    notifyListeners();
  }

  void _removeFromDevice() {
    SharedPreferences.getInstance().then((pref) {
      pref.remove(Constants.prefsToken);
    });
  }
}
