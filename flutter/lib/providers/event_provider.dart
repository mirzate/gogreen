import 'dart:convert';
import 'dart:io';

import 'package:gogreen/models/event.dart';
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/providers/token_provider.dart';
import 'package:gogreen/utils/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {
  static String? _baseURL;
  String _endpoint = "Event";

  EventProvider() {
    //GET
    //http://localhost:8080/api/Event

    _baseURL = const String.fromEnvironment("baseURL",
        defaultValue: "http://localhost:8080/api/");
  }
  // Task
  Future<SearchResult<Event>> get({dynamic params}) async {
    //int pageIndex = 1, int pageSize = 10,

    var url = "$_baseURL$_endpoint";
    //var url = "$_baseURL$_endpoint?pageIndex=$pageIndex&pageSize=$pageSize";

    if (params != null) {
      var queryString = getQueryString(params);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = getAndCreateHeaders();

    print(uri);
    var response = await http.get(uri, headers: headers);

    if (!!validateResponse(response)) {
      var data = jsonDecode(response.body);
      //print("Event data: $data");
      var result = SearchResult<Event>();
      result.totalCount = data['totalCount'];
      result.pageIndex = data['pageNumber'];
      result.pageSize = data['pageSize'];
      result.totalPages = data['totalPages'];
      var items = data['items'];

      if (items is List) {
        // Check if the 'items' field is a list
        for (var item in items) {
          /*
          Event event = Event();
          event.id = item['id'];
          event.description = item['description'];
          event.title = item['title'];
          */
          result.result.add(Event.fromJson(item));
        }
      }

      return result;
    } else {
      throw Exception("Oops, something bad happened!");
    }
  }

  Future<void> putEvent(Event eModel) async {
    var url = "$_baseURL$_endpoint/${eModel.id}";

    final body = json.encode(eModel.toJson());
    var headers = getAndCreateHeaders();
    print(url);
    print(body);
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

  Future<void> deleteEvent(Event eModel) async {
    var url = "$_baseURL$_endpoint/${eModel.id}";

    var headers = getAndCreateHeaders();

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        // Update was successful
        print("Successfully deleted");
      } else {
        // Handle the error if update was unsuccessful
        print("Not successfully deleted");
        //print(response.request);
        print(response.body);
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error was occur");
    }
  }

  Future<void> postEvent(Event e, File? selectedImage) async {
    var url = "$_baseURL$_endpoint";

    var headers = getAndCreateHeaders(contentType: "multipart/form-data");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['Title'] = e.title.toString();
    request.fields['Description'] = e.title.toString();
    request.fields['DateFrom'] = e.dateFrom.toString();
    request.fields['DateTo'] = e.dateTo.toString();
    request.fields['TypeId'] = e.eventType?.id.toString() ?? '';
    request.fields['Active'] = e.active.toString().toLowerCase();

    if (selectedImage != null) {
      var imageFile =
          await http.MultipartFile.fromPath('imageFile', selectedImage.path);
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
      print("Error was occur");
    }
  }

  Future<Event> uploadImage(Event eModel, File selectedImage) async {
    if (selectedImage == null) {
      // Return the original GreenIsland object if no image is selected
      return eModel;
    }

    var url = "$_baseURL$_endpoint/${eModel.id}/Image";
    var headers = getAndCreateHeaders(contentType: "multipart/form-data");

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['greenIslandId'] = eModel.id.toString();

    // Add the image file to the request
    var imageFile =
        await http.MultipartFile.fromPath('imageFile', selectedImage.path);
    request.files.add(imageFile);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded');

        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        // Create a new GreenIsland object from the response data
        var updatedGreenIsland = Event.fromJson(jsonResponse);
        return updatedGreenIsland;
      } else {
        // Image upload failed
        print('Image upload failed with status code: ${response.statusCode}');
        return eModel;
      }
    } catch (e) {
      // Handle the error if any
      print('Error uploading image: $e');
      // Return the original GreenIsland object if there is an error
      return eModel;
    }
  }

  Future<void> deleteEventImage(Event eModel, int id) async {
    var url = "$_baseURL$_endpoint/${eModel.id}/Image/${id}";

    //final body = json.encode(greenIsland.toJson());
    var headers = getAndCreateHeaders();
    //print(headers);
    //print(url);

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
        //body: body,
      );

      if (response.statusCode == 204) {
        // Update was successful
        print("Image was successfully deleted");
      } else {
        // Handle the error if update was unsuccessful
        print("Image was not successfully deleted");
        print(response.body);
      }
    } catch (error) {
      // Handle any exceptions that occur during the API call
      print("Error was occured");
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
