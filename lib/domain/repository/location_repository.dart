import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:testing/domain/models/location_model.dart';
import 'package:testing/env.dart';

class LocationRepository with ChangeNotifier {

  Map<String, String> _createAuthHeader( String token) {

      return {
        'Content-Type': "application/json",
        'access-token': token.toString(),
        'module': 'driver',
        'platform': 'android',
        'client-version': '1.1.10',
        'language': 'en',
        'device-id': 'dev1234567890',
        'operating-system-version': 'lollipop 14.3.2',
        'secure-key': 'EpdM82lwqxphrAFo'
      };


  }

  Future<Map<String, String>> getAuthHeader( String token) async {
    return _createAuthHeader(token);
  }

  Future<void> setLocation(LocationModel locationModel, String token) async {
    Uri uri = Uri.https(Env.uri, "/driver/set_location");
    return post(uri,
            headers: await getAuthHeader(token),
            body: json.encode(locationModel.toJson()))
        .then((value) {
          print(value.body);
      // _response = ResponseModal.fromJson(
      //     json.decode(utf8.decode(value.bodyBytes)));
      // if (_response?.errormodal?.code == 0) {
      //   ExceptionHandler.httpExceptionHandle(value.statusCode, "Successful");
      // }
      notifyListeners();
    });
  }
}
