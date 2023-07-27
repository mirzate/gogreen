import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TokenProvider with ChangeNotifier {

  String? _token;

  String? get token => _token;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
    
  }
}

