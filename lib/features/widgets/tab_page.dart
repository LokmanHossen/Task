import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_task/features/controllers/product_controller.dart';
import 'package:zavisoft_task/features/widgets/product_card.dart';

class TabPage extends StatefulWidget {
  const TabPage({
    super.key,
    required this.tabIndex,
    required this.productController,
  });

  final int tabIndex;
  final ProductController productController;

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final products = widget.productController.getProductsForTab(
        widget.tabIndex,
      );

      if (products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return RefreshIndicator(
        onRefresh: () => widget.productController.refreshData(),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: products[index]),
        ),
      );
    });
  }
}
