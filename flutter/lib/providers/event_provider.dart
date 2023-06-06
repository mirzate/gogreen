import 'dart:convert';

import 'package:gogreen/models/event.dart';
import 'package:gogreen/models/search_result.dart';
import 'package:gogreen/utils/util.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier{

  static String? _baseURL;
  String _endpoint = "Event";

  EventProvider(){
    //GET
    //http://localhost:8080/api/Event 

    _baseURL = const String.fromEnvironment("baseURL",defaultValue: "http://localhost:8080/api/");

  }
  // Task
  Future<SearchResult<Event>> get() async {
    var url = "$_baseURL$_endpoint";
    var uri = Uri.parse(url);
    var headers = getAndCreateHeaders();
    var response = await http.get(uri, headers: headers);

    if(!!validateResponse(response)){

      var data = jsonDecode(response.body);

      var result = SearchResult<Event>();
      result.count = data['totalCount'];
      
      var items = data['items'];

      if (items is List) { // Check if the 'items' field is a list
        for (var item in items) {
          Event event = Event();
          event.id = item['id'];
          event.description = item['description'];
          event.title = item['title'];
          result.result.add(event);
        }
      }
      
      return result;
    }else{
      throw new Exception("Something bad happend!");
    }

  }

  bool validateResponse(http.Response response){
      if (response.statusCode < 299){
        return true;
      }else if(response.statusCode == 401){
        throw new Exception("Unauthorized");
      }else{
        throw new Exception("Error!");
      }
  }

  Map<String, String> getAndCreateHeaders(){
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";
    String basicAuthentication = "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuthentication
    };

    return headers;
  }
}