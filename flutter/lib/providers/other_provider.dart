import 'dart:convert';

import 'package:gogreen/models/event.dart';
import 'package:gogreen/models/eco_violation.dart' as mEcoViolation;
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/utils/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherProvider with ChangeNotifier {
  static String? _baseURL;

  String _endpointEventType = "EventType";
  String _endpointMunicipality = "Municipality";
  String _endpointEcoViolationStatus = "EcoViolationStatus";
  String _messageToRabbitMQ = "MessageToRabbitMQ/subscribe";

  OtherProvider() {
    //GET
    //http://localhost:8080/api/Other

    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }

  Future<void> subscribeToMessage(String queueName) async {
    print("test");
    var url1 = "$_baseURL$_messageToRabbitMQ/?queueName=$queueName";
    var uri1 = Uri.parse(url1);
    print(uri1);
    var headers = getAndCreateHeaders(Authorization?.token ?? "");

    try {
      var response = await http.post(uri1, headers: headers);

      if (response.statusCode == 200) {
        // Update was successful
        print("Succesfully subscribed to Message");
      } else {
        // Handle the error if update was unsuccessful
        print("Not succesfully subscribed to Message: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error was occur");
      throw Exception("Oops, something bad happened!");
    }
  }

  Future<List<mEcoViolation.EcoViolationStatus>> getEcoViolationStatus(
      {dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpointEcoViolationStatus";
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
      return List<mEcoViolation.EcoViolationStatus>.from(
          data.map((json) => mEcoViolation.EcoViolationStatus.fromJson(json)));
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  Future<List<mEcoViolation.Municipality>> getMunicipalities(
      {dynamic params}) async {
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
      return List<mEcoViolation.Municipality>.from(
          data.map((json) => mEcoViolation.Municipality.fromJson(json)));
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  // Task
  Future<List<EventType>> getEventTypes({dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpointEventType";
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
      return List<EventType>.from(data.map((json) => EventType.fromJson(json)));
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
