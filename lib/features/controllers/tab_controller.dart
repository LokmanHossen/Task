import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTabController extends GetxController {
  final RxInt currentIndex = 0.obs;

  late TabController _tabController;
  late PageController pageController;

  bool _isAnimatingFromTab = false;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  void syncWithTabController(TabController controller) {
    _tabController = controller;
    _tabController.addListener(_handleTabBarChange);
  }

  void _handleTabBarChange() {
    if (_tabController.indexIsChanging) return;
    final newIndex = _tabController.index;
    if (newIndex != currentIndex.value) {
      currentIndex.value = newIndex;
    }
  }

  void changeTab(int index) {
    if (index == currentIndex.value) return;

    currentIndex.value = index;

    if (_tabController.index != index) {
      _isAnimatingFromTab = true;
      _tabController.animateTo(index);
    }

    pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then((_) => _isAnimatingFromTab = false);
  }

  void onPageSwiped(int newIndex) {
    if (newIndex == currentIndex.value) return;
    if (_isAnimatingFromTab) return;

    currentIndex.value = newIndex;

    _tabController.animateTo(newIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void animateToTab(int index) => changeTab(index);

  void disposeTabController() {
    _tabController.removeListener(_handleTabBarChange);
    _tabController.dispose();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
