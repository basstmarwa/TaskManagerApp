import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  Future<dynamic> doDelete([String? unencodedPath]) async {
    return _processRequest("DELETE",null, unencodedPath);
  }

  Future<dynamic> doPut(Object? body,
      [String? unencodedPath, Map<String, dynamic>? queryParameters]) async {
    return _processRequest("PUT", body, unencodedPath, queryParameters);
  }

  Future<dynamic> doGet(
      [String? unencodedPath, Map<String, dynamic>? queryParameters]) async {
    return _processRequest("GET", null, unencodedPath, queryParameters);
  }

  Future<dynamic> doPost(Object? body,
      [String? unencodedPath, Map<String, dynamic>? queryParameters]) async {
    return _processRequest("POST", body, unencodedPath, queryParameters);
  }

  Future<dynamic> _processRequest(String method, Object? body,
      [String? unencodedPath, Map<String, dynamic>? queryParameters]) async {
    final url = Uri.https('reqres.in', unencodedPath??'', queryParameters);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    const timeOut = Duration(seconds: 10);
    http.Response response;
    try {
      if ("DELETE" == method) {
        response = await http.delete(url).timeout(timeOut);
      } else if ("PUT" == method) {
        response =await http.put(url, headers: headers, body: body).timeout(timeOut);
      } else if ("GET" == method) {
        response = await http.get(url, headers: headers).timeout(timeOut);
      } else if ("POST" == method) {
        response =
            await http.post(url, headers: headers, body: body).timeout(timeOut);
      } else {
        throw "unsupported method $method";
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        return true;
      } else {
        return {};
      }
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('Timeout Error: $e');
      }
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Socket Error: $e');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('General Error: $e');
      }
    }
    return {};
  }
}
