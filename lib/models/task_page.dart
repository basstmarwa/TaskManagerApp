import 'package:task_manager_app/models/task.dart';

class TaskPage {
  TaskPage(
      {required this.page,
      required this.total,
      required this.totalPages,
      required this.data});

  final int page;
  final int total;
  final int totalPages;
  final List<Task> data;

  factory TaskPage.fromJson(Map<String, dynamic> pageJson) {
    List<Task> taskList = [];
    for (dynamic task in pageJson['data']) {
      taskList.add(Task.fromJson(task));
    }
    return TaskPage(
        page: pageJson["page"],
        total: pageJson["total"],
        totalPages: pageJson["total_pages"],
        data: taskList);
  }
}
