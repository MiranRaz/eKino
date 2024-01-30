import 'dart:convert';
import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/models/search_result.dart';
import 'package:ekino_admin/utils/util.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MoviesProvider with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint = "Movies";

  MoviesProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7127/");
  }

  Future<SearchResult<Movies>> get() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Movies>();

      result.count = data['count'];
      print("results -> ${result.result}");
      for (var item in data['result']) {
        result.result.add(Movies.fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unkown error, please restar the app and try again!");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception(
          "Something bad happened please try again, if the error persists please restart the app and try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }
}
