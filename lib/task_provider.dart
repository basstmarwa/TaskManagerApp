import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasksList = [];

  List<Task> get tasksList => _tasksList;

  void updateTaskInList(Task task) {
    tasksList[tasksList.indexWhere((element) => element.id == task.id)] = task;
    notifyListeners();
  }

  void addTaskToList(Task task) {
    final taskIsExist = tasksList.contains(task);
    if (taskIsExist) {
      _tasksList = tasksList.where((m) => m.id != task.id).toList();
    } else {
      _tasksList = [...tasksList, task];
    }
    notifyListeners();
  }

  void addAllTasksToList(List<Task> tasks) {
    for (Task task in tasks) {
      addTaskToList(task);
    }
    notifyListeners();
  }
}
