//login

import 'dart:convert';

import 'package:edoblog/models/api_response.dart';
import 'package:edoblog/models/user.dart';
import 'package:edoblog/constant.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    var url;
    final response = await http.post(url.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = user.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['error'];
        apiResponse.error = errors[errors.keys.elementsAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = serverError;
    }
  } catch (e) {}
}
