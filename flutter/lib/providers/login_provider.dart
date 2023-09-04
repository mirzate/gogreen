import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gogreen/models/user.dart';

import '../utils/util.dart';

class LoginProvider with ChangeNotifier {
  static String? _baseURL;
  String _endpoint = "auth/login";
  String _endpointRegister = "auth/register";
  String _endpointUser = "user";

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  LoginProvider() {
    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }

  Future<String?> register(BuildContext context, String username, String email,
      String password) async {
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
      } else if (response.statusCode == 409) {
        /*
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Registration Error'),
              content: Text('User with email or username already exists.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        */
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

  Future<User?> getUser() async {
    final uri = Uri.parse('$_baseURL$_endpointUser');
    var headers = getAndCreateHeaders();

    print("fetch User");
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        var user = User();
        user.id = jsonResponse['id'];
        user.email = jsonResponse['email'];
        user.municipality = Municipality.fromJson(jsonResponse['municipality']);
        user.roles = jsonResponse['roles'];
        Authorization.roles = jsonResponse['roles'];
        return user;
      }
    } catch (e) {
      print('get user error: $e');
    }

    return null; // Return null if user not loged in
  }

  Map<String, String> getAndCreateHeaders({String? contentType}) {
    var token = Authorization.token ?? "";
    var headers = {
      "Content-Type": contentType ?? "application/json",
      "Authorization": "Bearer ${token}"
    };

    return headers;
  }
}
