// Contrôleur GetX
import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController with GetSingleTickerProviderStateMixin {
  RxList<Product> products = <Product>[].obs;
  RxString selectedCategory = 'Group'.obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    
    loadProducts();
    animationController.forward();
  }

  void loadProducts() {
    isLoading.value = true;
    
    Future.delayed(Duration(milliseconds: 500), () {
      products.value = [
        Product(
          id: '1',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 45.00,
          maxPrice: 55.00,
          imageUrl: 'speaker',
          stock: 57,
          backgroundColor: Colors.grey[200]!,
        ),
        Product(
          id: '2',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 65.00,
          maxPrice: 85.00,
          imageUrl: 'magnifier',
          stock: 57,
          backgroundColor: Color(0xFFD4A574),
        ),
        Product(
          id: '3',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 48.00,
          maxPrice: 65.00,
          imageUrl: 'camera',
          stock: 57,
          backgroundColor: Colors.grey[300]!,
        ),
        Product(
          id: '4',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 45.00,
          maxPrice: 55.00,
          imageUrl: 'headphones',
          stock: 57,
          backgroundColor: Color(0xFFFFC107),
        ),
        Product(
          id: '5',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 45.00,
          maxPrice: 65.00,
          imageUrl: 'watch',
          stock: 57,
          backgroundColor: Colors.grey[200]!,
        ),
        Product(
          id: '6',
          name: 'Amazon Echo Plus (3nd Gen)',
          category: 'Premium Quality',
          minPrice: 45.00,
          maxPrice: 65.00,
          imageUrl: 'instant_camera',
          stock: 57,
          backgroundColor: Colors.grey[300]!,
        ),
      ];
      isLoading.value = false;
    });
  }

  List<Product> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
