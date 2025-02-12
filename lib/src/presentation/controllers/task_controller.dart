import 'dart:developer';

import 'package:get/get.dart';
import 'package:notes/core/services/hive_service.dart';
import 'package:notes/src/data/models/task.model.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  List<String> tempImgPath = [];

  @override
  void onInit() {
    super.onInit();

    _loadTasks();
  }

  void _loadTasks() {
    final box = HiveService.taskBox;
    tasks.assignAll(box.values.toList());
    tasks.forEach(
      (element) => log("ssss" + element.toJson().toString()),
    );
    _sortTasks();
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      if (a.status == TaskStatus.completed && b.status != TaskStatus.completed) {
        return 1;
      } else if (a.status != TaskStatus.completed && b.status == TaskStatus.completed) {
        return -1;
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });
    tasks.refresh();
  }

  void addTask(Task task) {
    final box = HiveService.taskBox;

    if (tasks.any((taskLlist) => taskLlist.title.toLowerCase() == task.title.toLowerCase())) {
      return;
    }

    box.put(task.id, task);
    tasks.add(task);
    tempImgPath.clear();
    log("task final" + task.toJson().toString());
    _loadTasks();
  }

  void updateTask(String id, Task updatedTask) {
    final box = HiveService.taskBox;
    box.delete(id);
    box.put(updatedTask.id, updatedTask);
    tasks.removeWhere(
      (element) => element.id == id,
    );

    _loadTasks();
  }

  void deleteTask(String id) {
    final box = HiveService.taskBox;
    box.delete(id);
    tasks.removeWhere((task) => task.id == id);
    _loadTasks();
  }

  void toggleTaskStatus(Task upd_task) {
    Task model = upd_task.copyWith(status: TaskStatus.completed);
    updateTask(upd_task.id, model);
  }
}
