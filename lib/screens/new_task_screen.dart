import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/task_provider.dart';
import '../service/task_service.dart';

class NewTaskScreen extends StatefulWidget {
  NewTaskScreen({super.key, this.task});

  Task? task;

  @override
  State<NewTaskScreen> createState() {
    return _NewTaskScreenState();
  }
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredTodo = '';
  late var newTask;

  final service = TaskService();

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.task == null) {
        newTask = await service.addTask(context, _enteredTitle, _enteredTodo);
        context.read<TaskProvider>().addTaskToList(newTask);
      } else {
        newTask = await service.updateTask(
            context, _enteredTitle, _enteredTodo, widget.task!.id);
        context.read<TaskProvider>().updateTaskInList(newTask);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task != null) {
      _enteredTitle = widget.task!.title;
      _enteredTodo = widget.task!.todo;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 20,
                decoration: const InputDecoration(
                  label: Text('title'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 20) {
                    return 'Must be between 1 and 20 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('ToDo'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 50) {
                          return 'Must be between 1 and 50 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredTodo = value!;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: widget.task == null? Text('Add Task'):Text('Update Task'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
