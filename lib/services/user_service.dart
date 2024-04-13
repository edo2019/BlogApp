import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:edoblog/models/api_response.dart';
import 'package:edoblog/models/user.dart';
import 'package:edoblog/constant.dart';
import 'package:http/http.dart' as http;

//login
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
        apiResponse.error = somethingwentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//register
Future<ApiResponse> regisrter(
    String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    var url;
    final response = await http.post(url.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });

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
        apiResponse.error = somethingwentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//user
Future<ApiResponse> getuserDetail(
    String name, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    var url;
    final response = await http.get(url.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bear $token'
    });

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
        apiResponse.error = somethingwentWrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token')??'';
}

//get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userid')?? 0;
}

//logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}
