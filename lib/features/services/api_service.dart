import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiService extends GetxService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Failed to load products');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Failed to load products for category: $category');
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<User> fetchUserProfile() async {
    try {
      // Using user 1 as demo
      final response = await http.get(Uri.parse('$baseUrl/users/1'));
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      throw Exception('Failed to load user profile');
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }
}