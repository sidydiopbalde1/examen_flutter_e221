import 'dart:convert';

import 'package:examen_flutter/app/modules/login/views/login_view.dart';
import 'package:examen_flutter/app/modules/models/LoginResponse.dart';
import 'package:examen_flutter/app/modules/models/User.dart';
import 'package:examen_flutter/app/modules/product/views/product_view.dart';
import 'package:examen_flutter/app/modules/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  // Instance du service API
  final ApiService _apiService = Get.find<ApiService>();

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
      // Préparer les données de connexion
      final loginData = {
        "email": emailController.text.trim(),
        "motDePasse": passwordController.text,
      };

      print('[LOGIN] Tentative de connexion pour: ${loginData['email']}');


      final response = await _apiService.postRequest('/auth/login', loginData);

      print('[LOGIN] Réponse API: $response');

      if (response['status'] == 'success' || response['statusCode']==200) {
 
        final data = response['data'];
        
        if (data != null) {
          final token = response['token'];
          final user = data;

          if (token != null && user != null) {
            // Sauvegarder le token et les données utilisateur
            await _saveUserData(token, user);
            
            // Créer l'objet LoginResponse pour cohérence
            final loginResponse = LoginResponse(
              success: true,
              message: response['message'] ?? 'Connexion réussie',
              token: token,
              user: User.fromJson(user),
            );

            print('🔐 [LOGIN] Connexion réussie pour: ${user['nom']}');

            await Future.delayed(Duration(milliseconds: 1500));
            Get.offAll(() => ProductView(),arguments: {
              "user":loginResponse.user

            }); 
            
          } else {
            throw Exception('Token ou données utilisateur manquants dans la réponse');
          }
        } else {
          throw Exception('Aucune donnée dans la réponse de l\'API');
        }
      } else {
        // L'erreur est déjà gérée par ApiService avec le snackbar
        print('🔐 [LOGIN] Échec de la connexion: ${response['message']}');
      }

    } catch (e) {
      print('🔐 [LOGIN] Erreur: $e');
      
      // Afficher une erreur uniquement si ce n'est pas déjà fait par ApiService
      if (!e.toString().contains('Erreur de connexion') && 
          !e.toString().contains('Erreur réponse')) {
        Get.snackbar(
          'Erreur',
          'Une erreur inattendue est survenue: ${e.toString()}',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 4),
          icon: Icon(Icons.error, color: Colors.red[800]),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Méthode pour sauvegarder les données utilisateur
  Future<void> _saveUserData(String token, Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', json.encode(user));
      await prefs.setBool('remember_me', rememberMe.value);
      
      // Optionnellement, sauvegarder individuellement les données utilisateur
      await prefs.setString('user_id', user['id'] ?? '');
      await prefs.setString('user_name', user['nom'] ?? '');
      await prefs.setString('user_email', user['email'] ?? '');
      
      print('🔐 [LOGIN] Token sauvegardé: ${token.substring(0, 20)}...');
      print('🔐 [LOGIN] Données utilisateur sauvegardées: ${user['nom']}');
      
    } catch (e) {
      print('🔐 [LOGIN] Erreur lors de la sauvegarde: $e');
    }
  }

  // Méthode pour récupérer le token sauvegardé
  Future<String?> getSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('🔐 [LOGIN] Erreur lors de la récupération du token: $e');
      return null;
    }
  }

  // Méthode pour récupérer les données utilisateur sauvegardées
  Future<Map<String, dynamic>?> getSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        return json.decode(userDataString);
      }
      return null;
    } catch (e) {
      print('🔐 [LOGIN] Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  // Méthode pour vérifier si l'utilisateur était connecté
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final rememberMe = prefs.getBool('remember_me') ?? false;
      return token != null && rememberMe;
    } catch (e) {
      print('🔐 [LOGIN] Erreur lors de la vérification de connexion: $e');
      return false;
    }
  }

  // Méthode pour la déconnexion
  Future<void> logout() async {
    try {
      // TODO: Appeler l'API de déconnexion si nécessaire
      // await _apiService.postRequest('/auth/logout', {});
      
      // Supprimer les données sauvegardées
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.remove('remember_me');
      await prefs.remove('user_id');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      
      print('🔐 [LOGOUT] Données utilisateur supprimées');
      
      // Rediriger vers la page de connexion
      Get.offAll(() => LoginView());
      
    } catch (e) {
      print('🔐 [LOGOUT] Erreur lors de la déconnexion: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}