import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import './scroll_controller.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = RxBool(false);
  final RxBool isLoggedIn = RxBool(false);
  final RxString errorMessage = RxString('');

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final loggedIn = await AuthService.isLoggedIn();
      final userId = await AuthService.getSavedUserId();

      if (loggedIn && userId != null) {
        await loadUserProfile(userId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking auth status: $e');
      }
    }
  }

  Future<bool> login(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (userId < 1 || userId > 10) {
        errorMessage.value = 'User ID must be between 1 and 10';
        isLoading.value = false;
        return false;
      }

  
      final user = await ApiService().fetchUser(userId);


      final saved = await AuthService.saveLoginState(userId);

      if (saved) {
        currentUser.value = user;
        isLoggedIn.value = true;
        isLoading.value = false;
        return true;
      } else {
        throw Exception('Failed to save login state');
      }
    } catch (e) {
      errorMessage.value = 'Login failed: ${e.toString()}';
      if (kDebugMode) {
        print('Login error: $e');
      }
      isLoading.value = false;
      return false;
    }
  }

  Future<void> loadUserProfile(int userId) async {
    try {
      isLoading.value = true;
      final user = await ApiService().fetchUser(userId);
      currentUser.value = user;
      isLoggedIn.value = true;
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      if (Get.isRegistered<ScrollControllerX>()) {
        Get.find<ScrollControllerX>().resetScroll();
      }
      
      await AuthService.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<void> refreshUserProfile() async {
    final userId = currentUser.value?.id;
    if (userId != null) {
      await loadUserProfile(userId);
    }
  }
}
