import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_task/features/widgets/expanded_header.dart';
import '../controllers/product_controller.dart';
import '../controllers/tab_controller.dart';
import '../controllers/scroll_controller.dart';
import '../widgets/collapsed_header.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/product_card.dart';

class ProductListingScreen extends StatelessWidget {
  ProductListingScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  final CustomTabController tabController = Get.put(CustomTabController());
  final ScrollControllerX scrollControllerX = Get.put(ScrollControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => productController.refreshData(),
        child: CustomScrollView(
          controller: scrollControllerX.scrollController,
          slivers: [
            // Collapsible header
            GetX<ScrollControllerX>(
              builder: (ctrl) {
                return SliverAppBar(
                  expandedHeight: 220,
                  collapsedHeight: 80,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.blue,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    title: ctrl.isHeaderCollapsed.value
                        ? CollapsedHeader(
                            onSearch: (query) {
                              // Handle search
                              if (kDebugMode) {
                                print('Searching for: $query');
                              }
                            },
                          )
                        : null,
                    background:
                        const ExpandedHeader(),
                  ),
                );
              },
            ),

            // Tab Bar - Now using Stateless widget
            SliverToBoxAdapter(
              child: GetBuilder<CustomTabController>(
                builder: (controller) {
                  return Container(
                    height: 50,
                    color: Colors.white,
                    child: Builder(
                      builder: (context) {
                        // Create TabController with proper vsync
                        final tabControllerWidget = TabController(
                          length: productController.categories.length,
                          vsync: Scaffold.of(context),
                          initialIndex: controller.currentIndex.value,
                        );

                        // Sync with our controller
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.syncWithTabController(tabControllerWidget);
                        });

                        return CustomTabBar(
                          tabController: tabControllerWidget,
                          onTabChanged: _onTabChanged,
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Tab content as Sliver
            GetX<ProductController>(
              builder: (ctrl) {
                if (ctrl.isLoading.value && ctrl.products.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (ctrl.errorMessage.isNotEmpty && ctrl.products.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(ctrl.errorMessage.value),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ctrl.refreshData(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Obx(() {
                  final currentIndex = tabController.currentIndex.value;
                  final products = ctrl.getProductsForTab(currentIndex);

                  return SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index < products.length) {
                          return ProductCard(product: products[index]);
                        }
                        return null;
                      }, childCount: products.length),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    scrollControllerX.saveTabPosition(tabController.currentIndex.value);

    tabController.changeTab(index);

    scrollControllerX.restoreTabPosition(index);
  }
}
