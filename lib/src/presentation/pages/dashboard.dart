import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes/core/utils/utils.dart';
import 'package:notes/src/data/models/category.model.dart';
import 'package:notes/src/data/models/task.model.dart';
import 'package:notes/src/presentation/controllers/category_controller.dart';
import 'package:notes/src/presentation/controllers/dashboard_controller.dart';
import 'package:notes/src/presentation/widgets/text_widget.dart';
import '../controllers/task_controller.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TaskController _taskController = Get.put(TaskController());

  final CategoryController _categoryController = Get.put(CategoryController());

  final DashboardController _dashboardController = Get.put(DashboardController());

  final TextEditingController _notesController = TextEditingController();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => _dashboardController.isKeyboardVisible.value
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.tag),
                      color: Colors.white,
                      onPressed: () {
                        print("Tag clicked");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      color: Colors.white,
                      onPressed: () async {
                        String? path = await Utils().pickAndSaveImage();

                        if (path != null) {
                          _taskController.tempImgPath.add(path);
                        }
                        // FocusScope.of(context).requestFocus(_focusNode);
                        SystemChannels.textInput.invokeMethod('TextInput.show');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.undo),
                      color: Colors.white,
                      onPressed: () {
                        // Undo action
                        print("Undo clicked");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.redo),
                      color: Colors.white,
                      onPressed: () {
                        // Redo action
                        print("Redo clicked");
                      },
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              _dashboardController.onVerticalDragControl(DragGesture.update);
            },
            onHorizontalDragUpdate: (details) {
              _dashboardController.onHorizontalDragControl(DragGesture.update, updDetails: details);
            },
            onHorizontalDragEnd: (details) {
              _dashboardController.onHorizontalDragControl(DragGesture.end);
            },
            child: Container(
              width: Get.width * 0.65,
              color: Colors.black,
              margin: EdgeInsets.only(bottom: Get.height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ..._categoryController.categories.map((category) => GestureDetector(
                              onTap: () {
                                _categoryController.toggleCategoryStatus(category.id);
                                _taskController.tasks.refresh();
                              },
                              child: AnimatedContainer(
                                duration: _dashboardController.defaultAnimDuration,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                margin: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                                decoration: BoxDecoration(
                                  color: category.status == CategoryStatus.selected
                                      ? Colors.grey[900]
                                      : Colors.transparent,
                                  borderRadius:
                                      BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                ),
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: _dashboardController.defaultAnimDuration,
                                    style: TextStyle(
                                      color:
                                          category.status == CategoryStatus.selected ? Colors.white : Colors.grey[400],
                                      fontSize: category.status == CategoryStatus.selected ? 20 : 16,
                                      fontWeight: category.status == CategoryStatus.selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    child: Text(
                                      category.title,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        ListTile(
                          onTap: () async {
                            String? title = await _dashboardController.showAlertWindow(context);

                            title != null ? _categoryController.addCategory(title) : null;
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.grey[400], size: 20),
                              const SizedBox(width: 8),
                              CustomTextWidget(
                                title: 'Add Category',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedContainer(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_dashboardController.radiusVal),
                    bottomLeft: Radius.circular(_dashboardController.radiusVal)),
                color: _dashboardController.categorySwipeProgress.value > 0 ? Colors.grey[900] : Colors.black,
              ),
              margin: EdgeInsets.only(
                left: _dashboardController.categorySwipeProgress.value > 0
                    ? Get.width * 0.65 * _dashboardController.categorySwipeProgress.value
                    : 0,
                top: _dashboardController.categorySwipeProgress.value > 0
                    ? Get.width * 0.23 * _dashboardController.categorySwipeProgress.value
                    : 0,
                bottom: _dashboardController.categorySwipeProgress.value > 0
                    ? Get.width * 0.13 * _dashboardController.categorySwipeProgress.value
                    : 0,
              ),
              duration: _dashboardController.defaultAnimDuration,
              curve: Curves.linear,
              child: GestureDetector(
                onVerticalDragStart: (details) {
                  _dashboardController.onVerticalDragControl(DragGesture.start);
                },
                onVerticalDragUpdate: (details) {
                  _dashboardController.onVerticalDragControl(DragGesture.update, updDetails: details);
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                onVerticalDragEnd: (details) async {
                  _dashboardController.onVerticalDragControl(DragGesture.end);
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                onHorizontalDragUpdate: (details) {
                  _dashboardController.onHorizontalDragControl(DragGesture.update, updDetails: details);
                },
                onHorizontalDragEnd: (details) {
                  _dashboardController.onHorizontalDragControl(DragGesture.end);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_dashboardController.radiusVal),
                      bottomLeft: Radius.circular(_dashboardController.radiusVal)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_dashboardController.radiusVal),
                          bottomLeft: Radius.circular(_dashboardController.radiusVal)),
                    ),
                    child: _TaskListContent(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _TaskListContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width * 0.5,
          margin: EdgeInsets.only(top: Get.width * 0.15, left: Get.width * 0.08),
          child: GestureDetector(
            onLongPress: () async {
              if (!_dashboardController.isCategoryOpen.value) {
                String? title = await _dashboardController.showAlertWindow(context,
                    title: _categoryController.selectedCategory.title);

                title != null ? _categoryController.updateCategory(title, _categoryController.selectedCategory) : null;
              }
            },
            child: AnimatedDefaultTextStyle(
              duration: _dashboardController.defaultAnimDuration,
              style: TextStyle(
                color: Colors.white,
                fontSize: _dashboardController.categorySwipeProgress.value > 0 ? Get.width * 0.075 : Get.width * 0.1,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              child: Text(_categoryController.selectedCategory.title),
            ),
          ),
        ),
        Expanded(
            child: Obx(
          () => GestureDetector(
            onVerticalDragStart: (details) {
              _dashboardController.onVerticalDragControl(DragGesture.start);
            },
            onVerticalDragUpdate: (details) {
              _dashboardController.onVerticalDragControl(DragGesture.update, updDetails: details);
            },
            onVerticalDragEnd: (details) async {
              _dashboardController.onVerticalDragControl(DragGesture.end);
            },
            child: Transform.translate(
              offset: Offset(0, _dashboardController.dragOffset.value),
              child: Column(
                children: [
                  if (!_dashboardController.isCategoryOpen.value &&
                      (_dashboardController.isDragging.value || _dashboardController.isKeyboardVisible.value))
                    Opacity(
                      opacity:
                          _dashboardController.isKeyboardVisible.value ? 1 : _dashboardController.dragProgress.value,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Get.width * 0.08,
                          right: 24.0,
                          top: 12.0,
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _notesController,
                          autofocus: true,
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintText: 'Add Thoughts ...?',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              List<String> imgPath = [];
                              if (_taskController.tempImgPath.isNotEmpty) {
                                imgPath.addAll(_taskController.tempImgPath);
                              }
                              _taskController.addTask(Task(
                                  title: value.trim(),
                                  category_id: _categoryController.selectedCategory.id,
                                  imageList: imgPath,
                                  createdAt: DateTime.now()));
                              _notesController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  Expanded(
                    child: Obx(() {
                      List<Task> filteredTask = _taskController.tasks
                          .where((task) => task.category_id == _categoryController.selectedCategory.id)
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        padding:
                            _dashboardController.isCategoryOpen.value ? EdgeInsets.only(top: 35) : EdgeInsets.all(0),
                        physics: _dashboardController.isCategoryOpen.value
                            ? const ClampingScrollPhysics()
                            : const BouncingScrollPhysics(),
                        itemCount: filteredTask.length,
                        itemBuilder: (context, index) {
                          final task = filteredTask[index];
                          return _buildDismissibleTaskItem(task, context);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildDismissibleTaskItem(Task task, BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: _dashboardController.isCategoryOpen.value
          ? DismissDirection.none
          : task.status == TaskStatus.completed
              ? DismissDirection.endToStart
              : DismissDirection.horizontal,
      background: _buildSwipeBackground(true, context),
      secondaryBackground: _buildSwipeBackground(false, context),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _taskController.deleteTask(task.id);
        } else if (direction == DismissDirection.startToEnd) {
          _taskController.toggleTaskStatus(task);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd && task.status == TaskStatus.completed) {
          return false;
        }
        return true;
      },
      child: _buildAnimatedTaskItem(task, context),
    );
  }

  Widget _buildSwipeBackground(bool isRightSwipe, BuildContext context) {
    return Container(
      color: isRightSwipe ? Colors.green.shade800 : Colors.red.shade800,
      alignment: isRightSwipe ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: isRightSwipe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isRightSwipe) ...[
            const Icon(Icons.check_circle, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            CustomTextWidget(title: 'Complete'),
          ],
          if (!isRightSwipe) ...[
            CustomTextWidget(title: 'Delete'),
            const SizedBox(width: 12),
            const Icon(Icons.delete_forever, color: Colors.white, size: 28),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedTaskItem(Task task, BuildContext context) {
    return AnimatedSwitcher(
      duration: _dashboardController.defaultAnimDuration,
      child: GestureDetector(
        onLongPress: () async {
          if (!_dashboardController.isCategoryOpen.value) {
            if (task.status == TaskStatus.notCompleted) {
              String? upd_text = await _dashboardController.showAlertWindow(context, title: task.title);
              if (upd_text != null) {
                Task updTask = Task(
                  createdAt: DateTime.now(),
                  title: upd_text,
                  category_id: _categoryController.selectedCategory.id,
                );
                _taskController.updateTask(task.id, updTask);
              }
            }
          }
        },
        child: Container(
          key: ValueKey(task.status),
          alignment: Alignment.centerLeft,
          child: ListTile(
            contentPadding: EdgeInsets.only(
              left: Get.width * 0.08,
              right: 24.0,
              top: 12.0,
              bottom: 12.0,
            ),
            title: _buildAnimatedText(task),
            trailing: _dashboardController.isCategoryOpen.value ? SizedBox() : _buildImageStack(task.imageList),
          ),
        ),
      ),
    );
  }

  Widget _buildImageStack(List<String> images) {
    if (images.isEmpty) {
      return const SizedBox();
    } else if (images.length == 1) {
      return _buildImagePreview(images[0]);
    } else {
      return Container(
        width: 48 * 2,
        height: 48,
        child: Stack(
          children: [
            for (int i = 0; i < images.length && i < 3; i++)
              Positioned(
                left: i == 0 ? i * 1.0 : (images.length == 2 ? i * 36.0 : i * 24.0),
                child: _buildImagePreview(images[i]),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildImagePreview(String imageUrl) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(File(imageUrl)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAnimatedText(Task task) {
    return AnimatedSwitcher(
      duration: _dashboardController.defaultAnimDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.5, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: Container(
        key: ValueKey(task.status),
        alignment: Alignment.centerLeft,
        child: AnimatedDefaultTextStyle(
          duration: _dashboardController.defaultAnimDuration,
          style: TextStyle(
            color: task.status == TaskStatus.completed ? Colors.grey : Colors.white,
            fontSize: _dashboardController.categorySwipeProgress.value > 0 ? Get.width * 0.03 : 18,
            decoration: task.status == TaskStatus.completed ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: Colors.grey,
            decorationThickness: 2,
          ),
          child: Text(task.title),
        ),
      ),
    );
  }
}
