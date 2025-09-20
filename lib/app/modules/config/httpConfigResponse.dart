import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ====================
// CONFIG CLASSES
// ====================


class HttpResponseConfig {
  static Map<String, dynamic> getResponseConfig(int statusCode) {
    switch (statusCode) {
      case 200:
        return {'status': 'success', 'message': 'Requête réussie'};
      case 201:
        return {'status': 'created', 'message': 'Ressource créée avec succès'};
      case 400:
        return {'status': 'error', 'message': 'Requête invalide'};
      case 401:
        return {'status': 'unauthorized', 'message': 'Non autorisé'};
      case 403:
        return {'status': 'forbidden', 'message': 'Accès interdit'};
      case 404:
        return {'status': 'not_found', 'message': 'Ressource non trouvée'};
      case 422:
        return {'status': 'validation_error', 'message': 'Erreur de validation'};
      case 500:
        return {'status': 'server_error', 'message': 'Erreur serveur interne'};
      default:
        return {'status': 'unknown', 'message': 'Erreur inconnue'};
    }
  }
}
