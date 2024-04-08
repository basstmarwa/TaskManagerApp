import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/data/task_list.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/screens/new_task_screen.dart';
import 'package:task_manager_app/service/task_service.dart';
import 'package:task_manager_app/task_provider.dart';

import '../cash_manager.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TasksScreen();
  }
}

class _TasksScreen extends State<TasksListScreen> {
  final service = TaskService();
  int currentPageIdx = 1;
  int totalPages = 1000;
  List<Task> taskList=[];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (CacheManager.isListExist() == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TaskProvider>(context, listen: false)
            .addAllTasksToList(CacheManager.getListFromSharedPreferences());
        // context.read<TaskProvider>().addAllTasksToList(CacheManager.getListFromSharedPreferences());
      });
    } else {
      // tasksList.clear();
      getTasksList();
    }
    _scrollController.addListener(_loadMoreData);

    super.initState();
  }

  getTasksList({int pageIndex = 1, int pageSize = 10}) {
    if (pageIndex > totalPages) {
      return;
    }
    service.getTasks(pageIndex, pageSize).then((taskPage) {
      setState(() {
        totalPages = taskPage.totalPages;
        context.read<TaskProvider>().addAllTasksToList(taskPage.data);

        taskList.addAll(taskPage.data);
      });
    }, onError: (error) {});
  }

  addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewTaskScreen(),
      ),
    );
  }

  updateTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewTaskScreen(
          task: task,
        ),
      ),
    );
  }

  deleteTask(Task task) {
    service.deleteTask(task.id);
  }

  void logout() {
    CacheManager.endSession();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      currentPageIdx += 1;
      setState(() {
        getTasksList(pageIndex: currentPageIdx);
      });
    }
  }

  @override
  Widget build(context) {
    final provider = Provider.of<TaskProvider>(context);

    if (CacheManager.isListExist() == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false)
          .addAllTasksToList(CacheManager.getListFromSharedPreferences());
      taskList=CacheManager.getListFromSharedPreferences();
      });}
    Widget content = const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularProgressIndicator(),
      ],
    ));

    if (taskList.isNotEmpty) {
      CacheManager.setListIntoSharedPreferences(taskList);

      content = Container(
        margin: EdgeInsets.only(bottom: 40),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: taskList.length,
          itemBuilder: (ctx, index) => Dismissible(
            // secondaryBackground: Container(color: Colors.redAccent),
            onDismissed: (direction) {
              deleteTask(taskList[index]);
            },
            // key: ValueKey(tasksList[index].id),
            key: UniqueKey(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                title:
                    Text(taskList[index].title, style: TextStyle(fontSize: 25)),
                leading: Container(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.task, size: 35),
                ),
                subtitle: Text(taskList[index].todo,
                    style: const TextStyle(fontSize: 20)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    updateTask(taskList[index]);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
