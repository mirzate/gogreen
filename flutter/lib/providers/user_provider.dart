import 'dart:convert';

import 'package:gogreen/models/user.dart';
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/utils/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  static String? _baseURL;

  String _endpointUser = "users";
  String _endpointMunicipality = "Municipality";

  UserProvider() {
    //GET
    //http://localhost:8080/api/Other

    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }

  // Task
  Future<SearchResult<User>> getUsers({dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpointUser";

    //var url = "$_baseURL$_endpoint?pageIndex=$pageIndex&pageSize=$pageSize";

    if (params != null) {
      var queryString = getQueryString(params);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = getAndCreateHeaders(Authorization?.token ?? "");

    print(uri);
    var response = await http.get(uri, headers: headers);

    if (!!validateResponse(response)) {
      var data = jsonDecode(response.body);
      //print("data: $data");

      var result = SearchResult<User>();
      result.totalCount = data['totalCount'];
      result.pageIndex = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalPages = data['totalPages'];
      var items = data['items'];

      if (items is List) {
        for (var item in items) {
          result.result.add(User.fromJson(item));
        }
      }
      return result;
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  Future<void> updateMunicipality(User user) async {
    var url =
        "$_baseURL$_endpointUser/${user.id}/municipality/${user.municipality?.id}";
    var headers = getAndCreateHeaders(Authorization?.token ?? "");
    print(url);
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: null,
      );

      if (response.statusCode == 200) {
        // Update was successful
        print("Update was successful");
      } else {
        // Handle the error if update was unsuccessful
        print("Update was unsuccessful");
        //print(response.request);
        print(response.body);
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error was occur");
    }
  }

  Future<void> approve(String id, bool isApproved) async {
    var url = "$_baseURL$_endpointUser/${id}/approve?isApproved=${isApproved}";
    var headers = getAndCreateHeaders(Authorization?.token ?? "");
    print(url);
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: null,
      );

      if (response.statusCode == 200) {
        // Update was successful
        print("Update was successful");
      } else {
        // Handle the error if update was unsuccessful
        print("Update was unsuccessful");
        //print(response.request);
        print(response.body);
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error was occur");
    }
  }

  Future<List<Municipality>> getMunicipalities({dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpointMunicipality";
    //var url = "$_baseURL$_endpoint?pageIndex=$pageIndex&pageSize=$pageSize";

    if (params != null) {
      var queryString = getQueryString(params);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = getAndCreateHeaders(Authorization?.token ?? "");

    print(uri);
    var response = await http.get(uri, headers: headers);

    if (!!validateResponse(response)) {
      var data = jsonDecode(response.body);
      return List<Municipality>.from(
          data.map((json) => Municipality.fromJson(json)));
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  bool validateResponse(http.Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      print(response.body);
      throw new Exception("Error!");
    }
  }

  Map<String, String> getAndCreateHeaders(String token) {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token}"
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix: '&', bool inRecursion: false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
