import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollControllerX extends GetxController {
  final ScrollController scrollController = ScrollController();
  final Map<int, double> tabScrollPositions = {};
  var isSwitchingTab = false.obs;
  var isHeaderCollapsed = false.obs;
  var currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      if (scrollController.offset > 180 && !isHeaderCollapsed.value) {
        isHeaderCollapsed.value = true;
      } else if (scrollController.offset <= 180 && isHeaderCollapsed.value) {
        isHeaderCollapsed.value = false;
      }
    }
  }

  void saveTabPosition(int tabIndex) {
    if (!isSwitchingTab.value && scrollController.hasClients) {
      tabScrollPositions[tabIndex] = scrollController.offset;
    }
  }

  void restoreTabPosition(int tabIndex) {
    currentTab.value = tabIndex;

    if (scrollController.hasClients) {
      if (tabScrollPositions.containsKey(tabIndex)) {
        isSwitchingTab.value = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(tabScrollPositions[tabIndex]!);
          }
          isSwitchingTab.value = false;
        });
      } else {
        scrollController.jumpTo(0);
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
