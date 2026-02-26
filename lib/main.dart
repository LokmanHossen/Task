import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft_task/features/controllers/product_controller.dart';
import 'package:zavisoft_task/features/controllers/scroll_controller.dart';
import 'package:zavisoft_task/features/controllers/tab_controller.dart';
import 'package:zavisoft_task/features/screens/product_listing_screen.dart';
import 'package:zavisoft_task/features/services/api_service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daraz Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductListingScreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ApiService(), permanent: true);
        Get.put(ProductController(), permanent: true);
        Get.put(CustomTabController(), permanent: true);
        Get.put(ScrollControllerX(), permanent: true);
      }),
    );
  }
}