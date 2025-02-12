import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/src/data/models/category.model.dart';
import 'package:notes/src/data/models/task.model.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(CategoryStatusAdapter());
    Hive.registerAdapter(TaskStatusAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());

    // Open boxes
    await Future.wait([
      Hive.openBox<Category>('categories'),
      Hive.openBox<Task>('tasks'),
    ]);
  }

  static Box<Category> get categoryBox => Hive.box<Category>('categories');
  static Box<Task> get taskBox => Hive.box<Task>('tasks');

  static Future<void> addDefaultCategory() async {
    var box = categoryBox;

    if (box.isEmpty) {
      Category defaultCategory = Category(
        createdAt: DateTime.now(),
        title: 'My Lists',
        status: CategoryStatus.selected,
      );

      await box.put(defaultCategory.id, defaultCategory);
    }
  }
}
