import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTabController extends GetxController {
  final RxInt currentIndex = 0.obs;
  late TabController tabController;

  void changeTab(int index) {
    if (index != currentIndex.value) {
      currentIndex.value = index;
    }
  }

  void syncWithTabController(TabController controller) {
    tabController = controller;
    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      final newIndex = tabController.index;
      if (newIndex != currentIndex.value) {
        currentIndex.value = newIndex;
      }
    }
  }

  void disposeController() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
  }

  void animateToTab(int index) {
    if (tabController.index != index) {
      tabController.animateTo(index);
    }
  }
}
