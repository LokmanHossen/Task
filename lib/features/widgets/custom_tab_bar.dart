import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class CustomTabBar extends StatelessWidget {
  final Function(int) onTabChanged;
  final TabController tabController;

  const CustomTabBar({
    super.key,
    required this.onTabChanged,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    
    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.label,
      onTap: onTabChanged,
      tabs: productController.categories.map((category) {
        return Tab(
          text: category.toUpperCase(),
        );
      }).toList(),
    );
  }
}