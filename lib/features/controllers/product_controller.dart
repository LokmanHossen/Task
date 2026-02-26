import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var products = <Product>[].obs;
  var filteredProducts = <Map<String, List<Product>>>[].obs;
  var user = Rxn<User>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final List<String> categories = [
    'all',
    "men's clothing",
    "women's clothing",
    'jewelery',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await Future.wait([fetchProducts(), fetchUserProfile()]);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      final allProducts = await _apiService.fetchProducts();
      products.value = allProducts;
      filterProductsByCategory();
    } catch (e) {
      rethrow;
    }
  }

  void filterProductsByCategory() {
    filteredProducts.clear();

    for (var category in categories) {
      if (category == 'all') {
        filteredProducts.add({'all': products.toList()});
      } else {
        final categoryProducts = products
            .where((p) => p.category == category)
            .toList();
        filteredProducts.add({category: categoryProducts});
      }
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final userProfile = await _apiService.fetchUserProfile();
      user.value = userProfile;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await fetchProducts();
      await fetchUserProfile();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> getProductsForTab(int tabIndex) {
    if (tabIndex < filteredProducts.length) {
      return filteredProducts[tabIndex].values.first;
    }
    return [];
  }
}
