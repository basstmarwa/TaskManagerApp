import 'dart:convert';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.todo,
    this.createdAt,
  });

  final int id;
  final String title;
  final String todo;
  final DateTime? createdAt;

  factory Task.fromJson(Map<String, dynamic> tasksJson) =>
      Task(
        id: tasksJson["id"],
        title: tasksJson["first_name"],
        todo: tasksJson["email"],
      );

  factory Task.taskFromJson(Map<String, dynamic> tasksJson) =>
      Task(
        id: tasksJson["id"],
        title: tasksJson["title"],
        todo: tasksJson["todo"],
      );
  static List<Task> getFromJsonList(String s) {
    Iterable l = jsonDecode(s);
    List<Task> posts = List<Task>.from(l.map((model)=> Task.taskFromJson(model)));

    return  posts;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'todo': todo,
    };


}}
