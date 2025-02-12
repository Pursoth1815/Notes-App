import 'package:get/get.dart';
import 'package:notes/core/services/hive_service.dart';
import 'package:notes/src/data/models/category.model.dart';

class CategoryController extends GetxController {
  RxList<Category> categories = <Category>[].obs;

  Category get selectedCategory {
    final selectedCategory = categories.firstWhere(
      (category) => category.status == CategoryStatus.selected,
    );

    return selectedCategory;
  }

  @override
  void onInit() {
    super.onInit();
    _loadCategory();
  }

  void _loadCategory() {
    final box = HiveService.categoryBox;
    categories.assignAll(box.values.toList());
    _sortCategory();
  }

  void _sortCategory() {
    categories.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    categories.refresh();
  }

  void updateCategory(String title, Category updatedTask) {
    categories.removeWhere(
      (element) => element.id == updatedTask.id,
    );
    final box = HiveService.categoryBox;
    Category model = updatedTask.copyWith(title: title);
    box.delete(updatedTask.id);
    box.put(model.id, model);
    _loadCategory();
    toggleCategoryStatus(model.id);
  }

  void addCategory(String title) {
    Category model = Category(
      title: title,
      createdAt: DateTime.now(),
    );
    final box = HiveService.categoryBox;
    if (categories.any((category) => category.title.toLowerCase() == title.toLowerCase())) {
      return;
    }
    box.put(model.id, model);
    categories.add(model);
    toggleCategoryStatus(model.id);
  }

  void toggleCategoryStatus(String id) {
    categories.value = categories.map((category) {
      if (category.id == id) {
        return category.copyWith(status: CategoryStatus.selected);
      } else {
        return category.copyWith(status: CategoryStatus.notSelected);
      }
    }).toList();
    _sortCategory();
  }
}
