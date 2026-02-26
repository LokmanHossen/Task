import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_task/features/widgets/expanded_header.dart';
import 'package:zavisoft_task/features/widgets/tab_page.dart';
import '../controllers/product_controller.dart';
import '../controllers/tab_controller.dart';
import '../controllers/scroll_controller.dart';
import '../widgets/collapsed_header.dart';
import '../widgets/custom_tab_bar.dart';

class ProductListingScreen extends StatelessWidget {
  ProductListingScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  final CustomTabController tabController = Get.put(CustomTabController());
  final ScrollControllerX scrollControllerX = Get.put(ScrollControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: NestedScrollView(
          controller: scrollControllerX.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            GetX<ScrollControllerX>(
              builder: (ctrl) {
                return SliverAppBar(
                  expandedHeight: 220,
                  collapsedHeight: 80,
                  pinned: true,
                  stretch: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: Colors.blue,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    titlePadding: EdgeInsets.zero, 
                    title: ctrl.isHeaderCollapsed.value
                        ? CollapsedHeader(
                            onSearch: (query) {
                              if (kDebugMode) print('Searching for: $query');
                            },
                          )
                        : null,
                    background: const ExpandedHeader(),
                  ),
                );
              },
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                height: 50,
                child: GetBuilder<CustomTabController>(
                  builder: (controller) {
                    return Container(
                      height: 50,
                      color: Colors.white,
                      child: Builder(
                        builder: (ctx) {
                          final tabControllerWidget = TabController(
                            length: productController.categories.length,
                            vsync: Scaffold.of(ctx),
                            initialIndex: controller.currentIndex.value,
                          );

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.syncWithTabController(
                              tabControllerWidget,
                            );
                          });

                          return CustomTabBar(
                            tabController: tabControllerWidget,
                            onTabChanged: _onTabTapped,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          body: GetX<ProductController>(
            builder: (ctrl) {
              if (ctrl.isLoading.value && ctrl.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctrl.errorMessage.isNotEmpty && ctrl.products.isEmpty) {
                return Center(
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
                );
              }

              return PageView.builder(
                controller: tabController.pageController,
                onPageChanged: tabController.onPageSwiped,
                itemCount: productController.categories.length,
                itemBuilder: (context, pageIndex) => TabPage(
                  tabIndex: pageIndex,
                  productController: productController,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    tabController.changeTab(index);
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.height != height || old.child != child;
}
