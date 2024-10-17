import 'dart:convert';
import 'package:ekino_mobile/models/reservation.dart';
import 'package:ekino_mobile/models/search_result.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:ekino_mobile/utils/util.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String? _endpoint;

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7127/");
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];
      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unkown error, please restar the app and try again!");
    }
  }

  Future<SearchResult<T>> getByUserId(int? id) async {
    var url = "$_baseUrl$_endpoint?UserId=$id";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];
      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unkown error, please restar the app and try again!");
    }
  }

  Future<T?> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unknown error, please restart the app and try again!");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unkown error, please try again!");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw Exception("Unkown error, please try again!");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      throw Exception(
          "Something bad happened please try again, if the error persists please restart the app and try again");
    }
  }

  Future<void> saveUsernameStateToLocalStorage(String usernameState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usernameState', usernameState);
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    saveUsernameStateToLocalStorage(username);

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
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
        query += '$prefix$key=${(value).toIso8601String()}';
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

  Future<bool> checkUsernameExists(String username) async {
    var url = "$_baseUrl$_endpoint/checkusername/$username";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unknown error, please try again!");
    }
  }

  Future<bool> checkEmailExists(String email) async {
    var url = "$_baseUrl$_endpoint/checkemail/$email";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unknown error, please try again!");
    }
  }

  Future<bool> checkPhoneExists(String phone) async {
    var url = "$_baseUrl$_endpoint/checkphone/$phone";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Unknown error, please try again!");
    }
  }

  Future<Users> getUsername(String username) async {
    var url = "$_baseUrl$_endpoint/getusername/$username";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var userData = jsonDecode(response.body);
      return Users.fromJson(userData);
    } else {
      throw Exception("Unknown error, please try again!");
    }
  }

  Future<void> register(Map<String, dynamic> user, BuildContext context) async {
    final baseUrl = _baseUrl!.endsWith('/')
        ? _baseUrl!.substring(0, _baseUrl!.length - 1)
        : _baseUrl;

    final response = await http.post(
      Uri.parse('$baseUrl/Users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin'))}',
      },
      body: json.encode(user),
    );

    if (response.statusCode == 200) {
      showModal(context, "Success", "User registered successfully!");
      Navigator.of(context).pop();
    } else {
      String errorMessage;
      try {
        if (response.body.isNotEmpty) {
          errorMessage =
              json.decode(response.body)['message'] ?? 'Unknown error occurred';
        } else {
          errorMessage = 'No response from server';
        }
      } catch (e) {
        errorMessage = 'Failed to parse error message: ${e.toString()}';
      }
      showModal(context, "Error", 'Failed to register user: $errorMessage');
    }
  }
}

void showModal(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
