import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/tab_controller.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabController;
  final Function(int) onTabChanged;

  const TabBarWidget({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<CustomTabController>(
      builder: (tabCtrl) {
        return Container(
          color: Colors.white,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: Get.find<ProductController>().categories.map((category) {
              return Tab(text: category.toUpperCase());
            }).toList(),
            onTap: (index) {
              onTabChanged(index);
            },
          ),
        );
      },
    );
  }
}
