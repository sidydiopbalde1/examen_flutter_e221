import 'dart:convert';
import 'dart:io';
import 'package:examen_flutter/app/modules/config/httpConfigResponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:examen_flutter/app/modules/config/config.dart';


class ApiService extends GetxService {
  RxBool isLoading = false.obs;
  RxString currentOperation = ''.obs;
  RxString baseUrl = "https://api-exam-flutter-l3.smartek.sn/".obs;
  // JSON POST
 Future<Map<String, dynamic>> postRequest(
    String endpoint,
    dynamic body, {
    String? token,
  }) async {
    try {
      isLoading.value = true;
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      print('🔍 [API_SERVICE] POST: ${Config.getApiUrl()}$endpoint');
      print('🔍 [API_SERVICE] Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
        body: json.encode(body),
      ).timeout(Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur de connexion: $e');
      throw Exception('Erreur de connexion: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // PUT
  Future<Map<String, dynamic>> putRequest(
    String endpoint,
    dynamic body, {
    String? token,
  }) async {
    try {
      isLoading.value = true;
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      print('🔍 [API_SERVICE] PUT: ${Config.getApiUrl()}$endpoint');
      print('🔍 [API_SERVICE] Body: ${json.encode(body)}');

      final response = await http.put(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
        body: json.encode(body),
      ).timeout(Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur PUT: $e');
      throw Exception('Erreur PUT: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE
  Future<Map<String, dynamic>> deleteRequest(
    String endpoint, {
    String? token,
  }) async {
    try {
      isLoading.value = true;
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      print('🔍 [API_SERVICE] DELETE: ${Config.getApiUrl()}$endpoint');

      final response = await http.delete(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
      ).timeout(Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur DELETE: $e');
      throw Exception('Erreur DELETE: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // PATCH
  Future<Map<String, dynamic>> patchRequest(
    String endpoint,
    dynamic body, {
    String? token,
  }) async {
    try {
      isLoading.value = true;
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      print('🔍 [API_SERVICE] PATCH: ${Config.getApiUrl()}$endpoint');
      print('🔍 [API_SERVICE] Body: ${json.encode(body)}');

      final response = await http.patch(
        Uri.parse("${Config.getApiUrl()}$endpoint"),
        headers: headers,
        body: json.encode(body),
      ).timeout(Duration(seconds: 30));

      return _handleResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur PATCH: $e');
      throw Exception('Erreur PATCH: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Multipart POST (VOTRE CODE)
  Future<Map<String, dynamic>> postMultipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
    String? token,
  }) async {
    try {
      isLoading.value = true;
      
      final uri = Uri.parse('${Config.getApiUrl()}$endpoint');

      final request = http.MultipartRequest('POST', uri)
        ..fields.addAll(fields)
        ..files.addAll(files);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      print('🔍 [API_SERVICE] Champs form-data envoyés: \n${request.fields}');
      print('🔍 [API_SERVICE] Headers envoyés: \n${request.headers}');
      
      final streamed = await request.send().timeout(Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur multipart: $e');
      throw Exception('Erreur multipart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET
  Future<Map<String, dynamic>> getRequest(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    try {
      isLoading.value = true;
      
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      var uri = Uri.parse("${Config.getApiUrl()}$endpoint");
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      print('🔍 [API_SERVICE] GET: $uri');

      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(Duration(seconds: 30));
      
      return handleProductResponse(response);
    } catch (e) {
      _showErrorSnackbar('Erreur GET: $e');
      throw Exception('Erreur GET: $e');
    } finally {
      isLoading.value = false;
    }
  }
Map<String, dynamic> handleProductResponse(http.Response response) {
  try {
    print('🔍 [API_SERVICE] Product Response Status: ${response.statusCode}');
    print('🔍 [API_SERVICE] Product Response Body: ${response.body}');

    final responseBody = json.decode(response.body);

    if (responseBody is Map<String, dynamic>) {
      // Structure standardisée pour les réponses produits
      final result = {
        'statusCode': response.statusCode,
        'success': response.statusCode >= 200 && response.statusCode < 300,
        'message': responseBody['message'] ?? _getDefaultMessage(response.statusCode),
        'data': responseBody['data'],
        'pagination': responseBody['pagination'],
        'errors': responseBody['errors'],
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Gestion spécifique selon le status code
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _showSuccessSnackbar(result['message']);
        
        // Log spécifique pour les produits
        if (result['data'] is List) {
          print('🔍 [PRODUCTS] ${(result['data'] as List).length} produits récupérés');
        } else if (result['data'] is Map && result['data']['_id'] != null) {
          print('🔍 [PRODUCTS] Produit traité: ${result['data']['nom']}');
        }
      } else {
        _showErrorSnackbar(result['message']);
        print('🔍 [PRODUCTS] Erreur: ${result['message']}');
      }

      return result;
    } else {
      throw Exception('Réponse produit mal formatée');
    }
  } catch (e) {
    print('🔍 [PRODUCTS] Erreur parsing: $e');
    _showErrorSnackbar('Erreur lors du traitement des données produits');
    
    // Retourner une structure d'erreur standardisée
    return {
      'statusCode': response.statusCode,
      'success': false,
      'message': 'Erreur lors du traitement: $e',
      'data': null,
      'pagination': null,
      'errors': ['Erreur de parsing: $e'],
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
String _getDefaultMessage(int statusCode) {
  switch (statusCode) {
    case 200:
      return 'Produits récupérés avec succès';
    case 201:
      return 'Produit créé avec succès';
    case 204:
      return 'Produit supprimé avec succès';
    case 400:
      return 'Données produit invalides';
    case 401:
      return 'Authentification requise';
    case 403:
      return 'Accès refusé aux produits';
    case 404:
      return 'Produit non trouvé';
    case 409:
      return 'Produit déjà existant';
    case 422:
      return 'Données produit incorrectes';
    case 500:
      return 'Erreur serveur lors du traitement des produits';
    default:
      return 'Erreur inconnue';
  }
}
  // Handler (VOTRE CODE)
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      print('🔍 [API_SERVICE] Status Code: ${response.statusCode}');
      print('🔍 [API_SERVICE] Response Body: ${response.body}');

      final responseBody = json.decode(response.body);
      print('🔍 [API_SERVICE] Response Body décodé: ${response.body}');
      if (responseBody is Map<String, dynamic>) {
        final config = HttpResponseConfig.getResponseConfig(response.statusCode);
        
        final result = {
          'statusCode': response.statusCode,
          'status': responseBody['status'] ?? config['status'],
          'message': responseBody['message'] ?? config['message'],
          'data': responseBody['user'],
          'token':responseBody['token'],
          'errors': responseBody['errors'],
          'meta': config,
        };

        // Afficher les notifications selon le statut
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _showSuccessSnackbar(result['message']);
        } else {
          _showErrorSnackbar(result['message']);
        }

        return result;
      } else {
        throw Exception('Réponse de l\'API mal formatée');
      }
    } catch (e) {
      _showErrorSnackbar('Erreur réponse: $e');
      throw Exception('Erreur réponse: $e');
    }
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Succès',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: Colors.green[800]),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      duration: Duration(seconds: 4),
      icon: Icon(Icons.error, color: Colors.red[800]),
    );
  }
}