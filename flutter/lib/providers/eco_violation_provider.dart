import 'dart:convert';
import 'dart:io';

import 'package:gogreen/models/event.dart';
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/utils/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/eco_violation.dart';

class EcoViolationProvider with ChangeNotifier {
  static String? _baseURL;
  String _endpoint = "EcoViolation";

  EcoViolationProvider() {
    //GET
    //http://localhost:8080/api/EcoViolation

    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }
  // Task
  Future<SearchResult<Ecoviolation>> get({dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpoint";
    //var url = "$_baseURL$_endpoint?pageIndex=$pageIndex&pageSize=$pageSize";

    if (params != null) {
      var queryString = getQueryString(params);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    print("Uri: $uri");

    var headers = getAndCreateHeaders();

    var response = await http.get(uri, headers: headers);

    if (!!validateResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<Ecoviolation>();
      result.totalCount = data['totalCount'];
      result.pageIndex = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalPages = data['totalPages'];
      var items = data['items'];

      if (items is List) {
        // Check if the 'items' field is a list
        for (var item in items) {
          result.result.add(Ecoviolation.fromJson(item));
        }
      }

      return result;
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  Future<void> putEcoViolation(Ecoviolation eModel) async {
    var url = "$_baseURL$_endpoint/${eModel.id}";

    final body = json.encode(eModel.toJson());
    var headers = getAndCreateHeaders();

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
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

  Future<void> postEcoViolation(
      Ecoviolation e, List<File> selectedImages) async {
    var url = "$_baseURL$_endpoint";

    var headers = getAndCreateHeaders(contentType: "multipart/form-data");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['Title'] = e.title.toString();
    request.fields['Description'] = e.title.toString();
    request.fields['MunicipalityId'] = e.municipality?.id.toString() ?? '';
    request.fields['Contact'] = e.contact?.toString() ?? '';

    for (var selectedImage in selectedImages) {
      var imageFile = await http.MultipartFile.fromPath(
        'imageFiles',
        selectedImage.path,
      );
      request.files.add(imageFile);
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 299) {
        // Update was successful
        print("Successful");
      } else {
        // Handle the error if update was unsuccessful
        print("Not successful");
        print(response.body);
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error occurred");
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

  Map<String, String> getAndCreateHeaders({String? contentType}) {
    var token = Authorization.token ?? "";
    var headers = {
      "Content-Type": contentType ?? "application/json",
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
