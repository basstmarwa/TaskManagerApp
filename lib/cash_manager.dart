import 'dart:convert';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/models/task.dart';

import 'models/user_model.dart';

class CacheManager{
  static const String TOKEN_KEY = "TOKEN_KEY";
  static const String USER_KEY = "USER_KEY";
  static const String LOGGED_IN_KEY = "LOGGED_IN_KEY";
  static const String TASK_LIST_KEY = "TASK_LIST_KEY";
  static const String IS_LIST_TASK_EXIST = 'IS_LIST_TASK_EXIST';


  static late SharedPreferences _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(IS_LIST_TASK_EXIST, 'false');
  }
  static String? isListExist() {
    return _preferences.getString(IS_LIST_TASK_EXIST);
  }

  static Future setListIntoSharedPreferences(List<Task> tasks) async {
    await _preferences.setString(TASK_LIST_KEY, jsonEncode(tasks));
    await _preferences.setString(IS_LIST_TASK_EXIST, 'true');
  }

  static List<Task> getListFromSharedPreferences()  {
    String? tasks= _preferences.getString(TASK_LIST_KEY);
    List<Task> list = Task.getFromJsonList(tasks!);
    return list;
  }

  static Future startSession(UserModel? user) async {
    await _preferences.setBool(LOGGED_IN_KEY, true);
    await _preferences.setString(USER_KEY, jsonEncode(user));
  }

  static Future endSession() async {
    await _preferences.setBool(LOGGED_IN_KEY, false);
    await _preferences.setString(USER_KEY, '');
    await _preferences.setString(TOKEN_KEY, '');
  }

  static bool? isLoggedIn() {
    return _preferences.getBool(LOGGED_IN_KEY);
  }

  static UserModel? getUser() {
    String? user = _preferences.getString(USER_KEY);
    return UserModel.fromJson(jsonDecode(user!));
  }

  static Future setToken(String data) async {
    await _preferences.setString(TOKEN_KEY, data);
  }

  static String? getToken() {
    return _preferences.getString(TOKEN_KEY);
  }
}

