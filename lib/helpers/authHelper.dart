//Packages Imports
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Config Imports
import '../config/urls.dart';
import '../pages/wellcome.dart';

class AuthHelper {
  static Future<void> _saveAuthPreferences(
      String tokenType, String token, String refreshToken) async {
    debugPrint('Entrou na _saveAuthPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tokenType', tokenType);
    prefs.setString('token', token);
    prefs.setString('refreshToken', refreshToken);
  }

  static Future<void> _saveUserData(
      String id, String customerId, String name, String email) async {
    debugPrint('Entrou na _saveUserData');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('customerId', customerId);
    prefs.setString('name', name);
    prefs.setString('email', email);
  }

  static Future<Map<String, String>> getAuthPreferences() async {
    debugPrint('Entrou na _getAuthPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenType = prefs.getString('tokenType');
    String token = prefs.getString('token');
    String refreshToken = prefs.getString('refreshToken');

    Map<String, String> authPreferences = {
      'tokenType': tokenType,
      'token': token,
      'refreshToken': refreshToken,
    };
    return authPreferences;
  }

  static Future<Map<String, String>> getUserData() async {
    debugPrint('Entrou na _getUserData');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('id');
    String customerId = prefs.getString('customerId');
    String name = prefs.getString('name');
    String email = prefs.getString('email');

    Map<String, String> userData = {
      'id': id,
      'customerId': customerId,
      'name': name,
      'email': email,
    };
    return userData;
  }

  static Future<bool> refreshToken(String refreshToken) async {
    Map<String, String> body = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken
    };

    Uri uri = Uri.http(UrlHelper.authUrl, '/oauth/token');
    http.Response response = await http.post(uri,
        body: body,
        headers: {
          'Accept': 'Aplication/json',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        encoding: Encoding.getByName('utf-8'));
    debugPrint('RefreshToken Status: ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      await _saveAuthPreferences(responseBody['token_type'],
          responseBody['access_token'], responseBody['refresh_token']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> me() async {
    Map<String, String> authPrefs = await getAuthPreferences();
    String tokenType = authPrefs['tokenType'];
    String token = authPrefs['token'];
    String refreshToken = authPrefs['refreshToken'];

    Map<String, String> header = {'Authorization': '$tokenType $token'};

    Uri uri = Uri.http(UrlHelper.authUrl, '/me');
    http.Response response = await http.get(uri, headers: header);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      await _saveUserData(
          responseBody['data']['id'],
          responseBody['data']['customerId'],
          responseBody['data']['name'],
          responseBody['data']['email']);
      return true;
    } else if (response.statusCode == 401) {
      bool success = await AuthHelper.refreshToken(refreshToken);
      if (success) {
        return me();
      } else {
        return false;
      }
    }
    return false;
  }

  static Future<bool> login(String username, String password) async {
    debugPrint('Entrou na login');
    Map<String, String> body = {
      'username': username,
      'password': password,
      'grant_type': 'password',
    };

    Uri uri = Uri.http(UrlHelper.authUrl, '/oauth/token');
    debugPrint(uri.toString());
    http.Response response =
        await http.post(uri, body: body, encoding: Encoding.getByName('utf-8'));
    debugPrint('Login Status' + response.statusCode.toString());

    Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      await _saveAuthPreferences(responseBody['token_type'],
          responseBody['access_token'], responseBody['refresh_token']);
      return true;
    }
    return false;
  }

  static Future<void> logout(BuildContext context) async {
    debugPrint('Entrou logout');
    //TODO: terminar logout
    Map<String, String> authPrefs = await getAuthPreferences();
    String tokenType = authPrefs['tokenType'];
    String token = authPrefs['token'];

    Map<String, String> header = {'Authorization': '$tokenType $token'};

    Uri uri = Uri.http(UrlHelper.authUrl, '/logout');
    http.Response response = await http.get(uri, headers: header);
    Map<String, dynamic> body = jsonDecode(response.body);
    debugPrint(body.toString());
    debugPrint('Logout status code: ' + response.statusCode.toString());
    await _saveUserData(null, null, null, null);
    await _saveAuthPreferences(null, null, null);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => WellCome()));
  }
}
