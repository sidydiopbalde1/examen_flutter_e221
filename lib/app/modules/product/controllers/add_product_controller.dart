
import 'package:examen_flutter/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Contrôleur pour le formulaire d'ajout
class AddProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final stockController = TextEditingController();
  final descriptionController = TextEditingController();
  
  RxBool isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString selectedBackgroundColor = '#E0E0E0'.obs;
  RxString selectedCategory = 'Premium Quality'.obs;

  final List<String> categories = [
    'Premium Quality',
    'Electronics',
    'Home & Garden',
    'Sports',
    'Fashion',
    'Books',
    'Health',
  ];

  final List<String> backgroundColors = [
    '#E0E0E0', // Gris
    '#FFC107', // Jaune
    '#D4A574', // Marron
    '#FF5722', // Orange
    '#4CAF50', // Vert
    '#2196F3', // Bleu
    '#9C27B0', // Violet
    '#F44336', // Rouge
  ];

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner l\'image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Utiliser le ProductController pour créer le produit
      final productController = Get.find<ProductController>();
      
      final success = await productController.createProductFromForm(
        name: nameController.text,
        category: selectedCategory.value,
        minPrice: double.parse(minPriceController.text),
        maxPrice: double.parse(maxPriceController.text),
        stock: int.parse(stockController.text),
        backgroundColorHex: selectedBackgroundColor.value,
        imageFile: selectedImage.value,
      );

      if (success) {
        _resetForm();
        Get.back(); // Fermer le modal
      }

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de l\'ajout: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    formKey.currentState?.reset();
    nameController.clear();
    categoryController.clear();
    minPriceController.clear();
    maxPriceController.clear();
    stockController.clear();
    descriptionController.clear();
    selectedImage.value = null;
    selectedBackgroundColor.value = '#E0E0E0';
    selectedCategory.value = 'Premium Quality';
  }

  @override
  void onClose() {
    nameController.dispose();
    categoryController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}