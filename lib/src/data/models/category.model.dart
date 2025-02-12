import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.model.g.dart';

@HiveType(typeId: 0)
enum CategoryStatus {
  @HiveField(0)
  selected,
  @HiveField(1)
  notSelected
}

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final CategoryStatus status;

  @HiveField(3)
  final DateTime createdAt;

  Category({
    String? id,
    required this.title,
    required this.createdAt,
    this.status = CategoryStatus.notSelected,
  }) : id = id ?? const Uuid().v4();

  Category copyWith({
    String? title,
    CategoryStatus? status,
    DateTime? createdAt,
  }) {
    return Category(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
