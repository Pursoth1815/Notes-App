import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes/src/presentation/widgets/bouncing_popup_alert.dart';

enum DragGesture { start, end, update }

class DashboardController extends GetxController with WidgetsBindingObserver {
  final isCategoryOpen = false.obs;
  final categorySwipeProgress = 0.0.obs;
  RxDouble dragOffset = 0.0.obs;
  RxDouble dragProgress = 0.0.obs;
  RxBool isDragging = false.obs;
  RxBool showTextField = false.obs;
  final defaultAnimDuration = const Duration(milliseconds: 300);
  final FocusNode textFieldFocusNode = FocusNode();

  var isKeyboardVisible = false.obs;

  double get radiusVal => categorySwipeProgress.value > 0 ? 30 : 0;

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    isKeyboardVisible.value = bottomInset > 0;
  }

  Future<String?> showAlertWindow(BuildContext context, {String? title}) async {
    String? title = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BouncingPopup();
      },
    );
    return title;
  }

  void onHorizontalDragControl(DragGesture gesture, {DragUpdateDetails? updDetails}) {
    if (isCategoryOpen.value) {
      if (gesture == DragGesture.update) {
        if (isCategoryOpen.value && updDetails!.delta.dx < 0) {
          categorySwipeProgress.value = -Get.width * 0.65 * (1 - categorySwipeProgress.value);
        }
      } else {
        if (isCategoryOpen.value) {
          if (categorySwipeProgress.value < 0.35) {
            isCategoryOpen.value = false;
            categorySwipeProgress.value = 0.0;
          } else {
            categorySwipeProgress.value = 1.0;
          }
        }
      }
    } else {
      if (gesture == DragGesture.update) {
        if (isCategoryOpen.value && updDetails!.delta.dx < 0) {
          categorySwipeProgress.value = (1 + (updDetails.delta.dx / (Get.width * 0.65))).clamp(0.0, 1.0);
        } else if (!isCategoryOpen.value && updDetails!.delta.dx > 0) {
          categorySwipeProgress.value = (updDetails.globalPosition.dx / Get.width).clamp(0.0, 1.0);
        }
      } else {
        if (isCategoryOpen.value) {
          if (categorySwipeProgress.value < 0.7) {
            isCategoryOpen.value = false;
            categorySwipeProgress.value = 0.0;
          } else {
            categorySwipeProgress.value = 1.0;
          }
        } else {
          if (categorySwipeProgress.value > 0.3) {
            isCategoryOpen.value = true;
            categorySwipeProgress.value = 1.0;
          } else {
            categorySwipeProgress.value = 0.0;
          }
        }
      }
    }
  }

  void onVerticalDragControl(DragGesture gesture, {DragUpdateDetails? updDetails}) {
    if (isCategoryOpen.value) {
      return;
    } else if (gesture == DragGesture.start) {
      return;
    } else if (gesture == DragGesture.update) {
      if (updDetails!.delta.dy < 0) return;
      isDragging.value = true;
      dragOffset.value += updDetails.delta.dy;
      dragOffset.value = dragOffset.value.clamp(0.0, 100.0);
      dragProgress.value = dragOffset.value / 100;
    } else {
      if (dragOffset.value > 80) {
        HapticFeedback.vibrate();
        showTextField.value = true;
      }
      isDragging.value = false;
      dragOffset.value = 0.0;
      dragProgress.value = 0.0;
      textFieldFocusNode.requestFocus();
    }
  }
}
