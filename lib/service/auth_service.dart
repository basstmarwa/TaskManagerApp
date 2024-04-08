import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager_app/service/http_service.dart';

class AuthService {
  final httpService = HttpService();

  Future<String> doLogin(
      BuildContext context, String userName, String password) async {
    Map<String, dynamic> response = await httpService.doPost(
        jsonEncode(
            {"username": userName, "email": userName, "password": password}),
        '/api/login');
    return response["token"];
  }
}
