import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/task_list.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/models/task_page.dart';
import 'package:task_manager_app/service/http_service.dart';

class TaskService {
  final httpService = HttpService();
  int pageIndex = 0;
  int totalPages = 0;

  Future<bool> deleteTask( int taskId) async {
    bool response = await httpService.doDelete('/api/users/$taskId');
    return response;
  }

  Future<dynamic> updateTask(
      BuildContext context, String title, String todo, int taskId) async {
    Map<dynamic, dynamic> response = await httpService.doPut(
        jsonEncode({"name": title, "job": todo}), '/api/users/$taskId');
    return Task(
        title: response['name'],
        id: taskId,
        todo: response['job'],
        // createdAt: response['updatedAt']
    );
  }

  Future<dynamic> addTask(
      BuildContext context, String title, String todo) async {
    Map<dynamic, dynamic> response = await httpService.doPost(
        jsonEncode({"name": title, "job": todo}), '/api/users');
    return Task(
        title: response['name'],
        id: int.parse(response['id']),
        todo: response['job'],
        // createdAt: response['createdAt']
    );
  }

  Future<TaskPage> getTasks(int pageIndex, int pageSize) async {
    dynamic response = await httpService.doGet('/api/users',
        {'page': pageIndex.toString(), 'per_page': pageSize.toString()});
    return TaskPage.fromJson(response);
  }
}
