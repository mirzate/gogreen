import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  static String? _baseURL;
  String _endpoint = "auth/login";
  String _endpointRegister = "auth/register";
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  LoginProvider() {
    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }

  Future<String?> register(
      String username, String email, String password) async {
    final url = Uri.parse('$_baseURL$_endpointRegister');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(
        {'userName': username, 'email': email, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Register 200");
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['access_token'] as String?;
        notifyListeners();
        return token;
      }
    } catch (e) {
      print('Login error: $e');
    }

    return null; // Return null if login fails
  }

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$_baseURL$_endpoint');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['access_token'] as String?;
        notifyListeners();
        return token;
      }
    } catch (e) {
      print('Login error: $e');
    }

    return null; // Return null if login fails
  }
}
