
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// ====================
// MODELS ET CONTRÔLEURS
// ====================

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Simulation d'appel API
      await Future.delayed(Duration(seconds: 2));

      // TODO: Remplacer par votre logique d'authentification
      if (emailController.text == 'admin@test.com' && passwordController.text == 'password') {
        Get.snackbar(
          'Succès',
          'Connexion réussie !',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
        
        // Navigation vers l'écran principal
        Get.offAllNamed('/products'); // ou Get.offAll(() => ProductManagementScreen());
      } else {
        throw Exception('Email ou mot de passe incorrect');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}