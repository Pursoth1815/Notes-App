import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.model.g.dart';

@HiveType(typeId: 2)
enum TaskStatus {
  @HiveField(0)
  completed,
  @HiveField(1)
  notCompleted
}

@HiveType(typeId: 3)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}

@HiveType(typeId: 4)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final TaskStatus status;

  @HiveField(3)
  final TaskPriority priority;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String category_id;

  @HiveField(6)
  final List<String> imageList;

  Task({
    String? id,
    List<String>? imageList,
    required this.category_id,
    required this.title,
    required this.createdAt,
    this.status = TaskStatus.notCompleted,
    this.priority = TaskPriority.medium,
  })  : id = id ?? const Uuid().v4(),
        imageList = imageList ?? [];

  Task copyWith({
    String? title,
    String? category_id,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? imageList,
    DateTime? createdAt,
  }) {
    return Task(
      id: id,
      category_id: category_id ?? this.category_id,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      imageList: imageList ?? this.imageList,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': category_id,
      'title': title,
      'status': status.toString(),
      'priority': priority.toString(),
      'imageList': imageList.toString(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
