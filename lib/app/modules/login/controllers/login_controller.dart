import 'package:examen_flutter/app/modules/models/LoginResponse.dart';
import 'package:examen_flutter/app/modules/product/views/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pré-remplir avec les données de test
    emailController.text = 'sididiop53@gmail.com';
    passwordController.text = 'passer123';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Simulation d'appel API
      await Future.delayed(Duration(seconds: 2));

      final response = {
        "success": true,
        "message": "Connexion réussie",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OGNmMTFiMjViY2ZhNTBjZmYzM2U1NjUiLCJpYXQiOjE3NTg0MDE1NzUsImV4cCI6MTc1OTAwNjM3NX0.z5rwV29Hi_LkcTn7GoXG7Bnjm4zFik_YPuXyRkra1kE",
        "user": {
          "id": "68cf11b25bcfa50cff33e565",
          "nom": "Sidy Diop Balde",
          "email": "sididiop53@gmail.com"
        }
      };

      final loginResponse = LoginResponse.fromJson(response);

      if (loginResponse.success) {
        // Sauvegarder le token et les données utilisateur
        // Ici vous pouvez utiliser SharedPreferences ou GetStorage
        
        Get.snackbar(
          'Succès',
          loginResponse.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Rediriger vers la page principale
        // Get.offAllNamed('/dashboard');
        // Ou pour l'exemple, rediriger vers ProductView
        Get.offAll(() => ProductView()); // Remplacez par votre page principale
      } else {
        Get.snackbar(
          'Erreur',
          loginResponse.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la connexion',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
