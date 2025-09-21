import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:examen_flutter/app/modules/services/api_service.dart';
class ProductController extends GetxController with GetSingleTickerProviderStateMixin {
  // ========== VARIABLES ==========
  RxList<Product> products = <Product>[].obs;
  RxString selectedCategory = 'Group'.obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isDeleting = false.obs;
  RxString errorMessage = ''.obs;
  
  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMoreProducts = true.obs;
  RxInt totalProducts = 0.obs;
  
  // Filtres et tri
  RxString sortBy = 'name'.obs;
  RxString sortOrder = 'asc'.obs;
  RxList<String> availableCategories = <String>[].obs;
  
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  
  // Instance du service API
  ApiService get _apiService => Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<ApiService>()) {
      Get.put(ApiService());
    }
    _initializeAnimations();
    loadProducts();
    animationController.forward();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  // ========== CHARGEMENT DES PRODUITS ==========
  
  Future<void> loadProducts({
    bool refresh = false,
    int? page,
    int limit = 20,
  }) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        products.clear();
      }
      
      isLoading.value = true;
      errorMessage.value = '';

      // Récupérer le token d'authentification
      final token = await _getAuthToken();
      print('TOOOOOOOOOOOOOOOKENNNNNN ${token}');
      if (token == null) {
        print('🔍 [PRODUCTS] Token manquant, chargement des données de fallback');
        _loadFallbackData();
        return;
      }

      // Construire les paramètres de requête
      final queryParams = <String, String>{
        'page': (page ?? currentPage.value).toString(),
        'limit': limit.toString(),
      };

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      if (selectedCategory.value != 'Group') {
        queryParams['categorie'] = selectedCategory.value;
      }

      print('🔍 [PRODUCTS] Chargement avec params: $queryParams');

      // Appel à l'API
      final response = await _apiService.getRequest(
        '/products',
        token: token,
        queryParams: queryParams,
      );
      print('------------------------PRODUCTS-----------------------');
      print('🔍 [PRODUCTS] Réponse API: ${response['statusCode']}');

      if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
        final data = response['data'];
        print('DATTTTTTTTTA $data');
        if (data != null) {
          List<Product> newProducts = [];
          
          // Vérifier si la réponse contient directement un tableau ou un objet avec pagination
          if (data is List) {
            // Réponse directe avec tableau de produits
            newProducts = data.map((json) => Product.fromApiJson(json)).toList();
            hasMoreProducts.value = newProducts.length >= limit;
          } else if (data is Map && data.containsKey('data')) {
            // Réponse avec pagination
            final productsData = data as List?;
            final pagination = response['pagination'];
            
            if (productsData != null) {
              newProducts = productsData.map((json) => Product.fromApiJson(json)).toList();
            }
            
            if (pagination != null) {
              totalPages.value = pagination['totalPages'] ?? 1;
              totalProducts.value = pagination['totalProducts'] ?? 0;
              hasMoreProducts.value = pagination['hasNext'] ?? false;
            }
          } else {
            // Réponse directe avec tableau
            newProducts = [data].map((json) => Product.fromApiJson(json)).toList();
          }

          if (refresh || currentPage.value == 1) {
            products.clear();
          }
          
          products.addAll(newProducts);
          _updateAvailableCategories();
          
          print('🔍 [PRODUCTS] ${newProducts.length} produits chargés');
        }
      } else {
        errorMessage.value = response['message'] ?? 'Erreur lors du chargement';
        print('🔍 [PRODUCTS] Erreur API: ${response['message']}');
        _loadFallbackData();
      }

    } catch (e) {
      print('🔍 [PRODUCTS] Exception: $e');
      errorMessage.value = 'Erreur de connexion: $e';
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  // ========== CRÉATION DE PRODUIT ==========

  Future<bool> createProduct(Product product) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      if (!_validateProduct(product)) {
        return false;
      }

      final token = await _getAuthToken();
      if (token == null) {
        _showErrorSnackbar('Token d\'authentification manquant');
        return false;
      }

      // Convertir au format API
      final productData = product.toApiJson();
      
      print('🔍 [PRODUCTS] Création produit: $productData');

      final response = await _apiService.postRequest(
        '/products',
        productData,
        token: token,
      );

      if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
        print('🔍 [PRODUCTS] Produit créé avec succès');
        // Recharger la liste des produits
        await loadProducts(refresh: true);
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Erreur lors de la création';
        return false;
      }

    } catch (e) {
      print('🔍 [PRODUCTS] Erreur création: $e');
      errorMessage.value = 'Erreur lors de la création: $e';
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  Future<bool> createProductFromForm({
    required String name,
    required String category,
    required double minPrice,
    required double maxPrice,
    required int stock,
    required String backgroundColorHex,
    String? imageUrl,
    File? imageFile,
    String? description,
  }) async {
    try {
      isCreating.value = true;

      // Créer le produit selon le nouveau modèle
      final product = Product.fromHexColor(
        name: name.trim(),
        description: description ?? 'Description du produit',
        price: minPrice, // Utiliser le prix minimum comme prix unique
        category: category,
        stock: stock,
        backgroundColorHex: backgroundColorHex,
      );

      // Si une image est sélectionnée, l'uploader d'abord
      if (imageFile != null) {
        print('🔍 [PRODUCTS] Upload d\'image en cours...');
        final uploadSuccess = await _uploadProductImage(imageFile);
        if (!uploadSuccess) {
          _showErrorSnackbar('Erreur lors de l\'upload de l\'image');
          return false;
        }
      }

      return await createProduct(product);

    } catch (e) {
      print('🔍 [PRODUCTS] Erreur création formulaire: $e');
      errorMessage.value = 'Erreur lors de la création: $e';
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ========== UPLOAD D'IMAGE ==========

  Future<bool> _uploadProductImage(File imageFile) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return false;

      // Créer le multipart file
      final multipartFile = await http.MultipartFile.fromPath(
        'images', // Nom du champ selon votre API
        imageFile.path,
      );

      final response = await _apiService.postMultipartRequest(
        endpoint: '/products/upload', // Adaptez selon votre endpoint
        fields: {}, // Ajoutez des champs si nécessaire
        files: [multipartFile],
        token: token,
      );

      return response['statusCode'] >= 200 && response['statusCode'] < 300;

    } catch (e) {
      print('🔍 [PRODUCTS] Erreur upload image: $e');
      return false;
    }
  }

  // ========== MISE À JOUR DE PRODUIT ==========
// Remplacez la méthode updateProduct dans votre ProductController par celle-ci :

Future<bool> updateProduct(String id, Product updatedProduct) async {
  try {
    isUpdating.value = true;
    errorMessage.value = '';

    final token = await _getAuthToken();
    if (token == null) {
      _showErrorSnackbar('Token d\'authentification manquant');
      return false;
    }

    // Convertir au format API pour la mise à jour
    final productData = updatedProduct.toApiJson();
    
    print('🔍 [PRODUCTS] Mise à jour produit ID: $id');
    print('🔍 [PRODUCTS] Données: $productData');

    final response = await _apiService.putRequest(
      '/products/$id',
      productData,
      token: token,
    );

    if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
      print('🔍 [PRODUCTS] Produit mis à jour avec succès');
      
      // Mettre à jour localement le produit dans la liste
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct;
        _updateAvailableCategories();
      }
      
      // Optionnellement, recharger la liste pour synchroniser avec le serveur
      // await loadProducts(refresh: true);
      
      _showSuccessSnackbar('Produit modifié avec succès');
      return true;
    } else {
      errorMessage.value = response['message'] ?? 'Erreur lors de la mise à jour';
      _showErrorSnackbar(errorMessage.value);
      return false;
    }

  } catch (e) {
    print('🔍 [PRODUCTS] Erreur mise à jour: $e');
    errorMessage.value = 'Erreur lors de la mise à jour: $e';
    _showErrorSnackbar(errorMessage.value);
    return false;
  } finally {
    isUpdating.value = false;
  }
}

// Ajoutez cette méthode pour la mise à jour partielle (utile pour des champs spécifiques)
Future<bool> partialUpdateProduct(String id, Map<String, dynamic> updates) async {
  try {
    isUpdating.value = true;
    errorMessage.value = '';

    final token = await _getAuthToken();
    if (token == null) {
      _showErrorSnackbar('Token d\'authentification manquant');
      return false;
    }

    print('🔍 [PRODUCTS] Mise à jour partielle produit ID: $id');
    print('🔍 [PRODUCTS] Champs modifiés: $updates');

    final response = await _apiService.patchRequest(
      '/products/$id',
      updates,
      token: token,
    );

    if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
      print('🔍 [PRODUCTS] Mise à jour partielle réussie');
      
      // Mettre à jour localement
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        final currentProduct = products[index];
        
        // Créer une copie mise à jour du produit
        Product updatedProduct = currentProduct.copyWith(
          name: updates['nom'] ?? currentProduct.name,
          description: updates['description'] ?? currentProduct.description,
          price: updates['prix']?.toDouble() ?? currentProduct.price,
          category: updates['categorie'] ?? currentProduct.category,
          stock: updates['stock'] ?? currentProduct.stock,
          updatedAt: DateTime.now(),
        );
        
        products[index] = updatedProduct;
        _updateAvailableCategories();
      }
      
      _showSuccessSnackbar('Produit modifié avec succès');
      return true;
    } else {
      errorMessage.value = response['message'] ?? 'Erreur lors de la mise à jour';
      _showErrorSnackbar(errorMessage.value);
      return false;
    }

  } catch (e) {
    print('🔍 [PRODUCTS] Erreur mise à jour partielle: $e');
    errorMessage.value = 'Erreur lors de la mise à jour: $e';
    _showErrorSnackbar(errorMessage.value);
    return false;
  } finally {
    isUpdating.value = false;
  }
}
  // ========== SUPPRESSION DE PRODUIT ==========

  Future<bool> deleteProduct(String id) async {
    try {
      isDeleting.value = true;
      errorMessage.value = '';

      final confirmed = await _showDeleteConfirmation();
      if (!confirmed) return false;

      final token = await _getAuthToken();
      if (token == null) {
        _showErrorSnackbar('Token d\'authentification manquant');
        return false;
      }

      final response = await _apiService.deleteRequest(
        '/products/$id',
        token: token,
      );

      if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
        products.removeWhere((p) => p.id == id);
        _updateAvailableCategories();
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Erreur lors de la suppression';
        return false;
      }

    } catch (e) {
      print('🔍 [PRODUCTS] Erreur suppression: $e');
      errorMessage.value = 'Erreur lors de la suppression: $e';
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  // ========== MISE À JOUR DU STOCK ==========

  Future<bool> updateProductStock(String id, int newStock) async {
    try {
      if (newStock < 0) {
        _showErrorSnackbar('Le stock ne peut pas être négatif');
        return false;
      }

      final token = await _getAuthToken();
      if (token == null) {
        _showErrorSnackbar('Token d\'authentification manquant');
        return false;
      }

      final response = await _apiService.patchRequest(
        '/products/$id',
        {'stock': newStock},
        token: token,
      );

      if (response['statusCode'] >= 200 && response['statusCode'] < 300) {
        // Mettre à jour localement
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = products[index].copyWith(
            stock: newStock,
            updatedAt: DateTime.now(),
          );
        }
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Erreur lors de la mise à jour du stock';
        return false;
      }

    } catch (e) {
      print('🔍 [PRODUCTS] Erreur mise à jour stock: $e');
      _showErrorSnackbar('Erreur lors de la mise à jour du stock: $e');
      return false;
    }
  }

  // ========== RECHERCHE ET FILTRES ==========

  void searchProducts(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts.value || isLoading.value) return;
    
    currentPage.value++;
    await loadProducts(page: currentPage.value);
  }

  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  // ========== DONNÉES DE FALLBACK ==========

  void _loadFallbackData() {
    print('🔍 [PRODUCTS] Chargement des données de fallback');
    products.value = [
      Product(
        id: '1',
        name: 'iPhone 14 Pro',
        description: 'Smartphone Apple dernière génération avec puce A16',
        price: 1299.99,
        category: 'electronique',
        stock: 25,
        backgroundColor: Colors.deepPurpleAccent,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S23',
        description: 'Flagship Android avec caméra avancée',
        price: 999.99,
        category: 'electronique',
        stock: 18,
        backgroundColor: Colors.orangeAccent,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      Product(
        id: '3',
        name: 'MacBook Air M2',
        description: 'Ordinateur portable ultra-léger Apple',
        price: 1499.99,
        category: 'electronique',
        stock: 12,
        backgroundColor: Colors.red,
        createdAt: DateTime.now().subtract(Duration(days: 7)),
      ),
      Product(
        id: '4',
        name: 'Table de Salon',
        description: 'Table moderne en bois massif',
        price: 299.99,
        category: 'maison',
        stock: 8,
        backgroundColor: Colors.yellow,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      Product(
        id: '5',
        name: 'Chaise de Bureau',
        description: 'Chaise ergonomique pour bureau',
        price: 199.99,
        category: 'maison',
        stock: 5,
        backgroundColor: Colors.green,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Product(
        id: '6',
        name: 'T-shirt Premium',
        description: 'T-shirt 100% coton bio',
        price: 29.99,
        category: 'vetements',
        stock: 50,
        backgroundColor: Colors.blue,
        createdAt: DateTime.now(),
      ),
    ];
    _updateAvailableCategories();
  }

  // ========== UTILITAIRES ==========

  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print('🔍 [PRODUCTS] Erreur récupération token: $e');
      return null;
    }
  }

  bool _validateProduct(Product product) {
    if (product.name.trim().isEmpty) {
      _showErrorSnackbar('Le nom du produit est requis');
      return false;
    }

    if (product.price < 0) {
      _showErrorSnackbar('Le prix ne peut pas être négatif');
      return false;
    }

    if (product.stock < 0) {
      _showErrorSnackbar('Le stock ne peut pas être négatif');
      return false;
    }

    return true;
  }

  Future<bool> _showDeleteConfirmation() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ce produit ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _updateAvailableCategories() {
    final categories = products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'Group');
    availableCategories.value = categories;
  }

  // ========== FILTRES ET GETTERS ==========

  List<Product> get filteredProducts {
    var filtered = products.where((product) {
      final matchesSearch = searchQuery.value.isEmpty || 
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'Group' || 
          product.category == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();

    return filtered;
  }

  // ========== NOTIFICATIONS ==========

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

  // ========== STATISTIQUES ==========

  Map<String, dynamic> get productStats {
    if (products.isEmpty) {
      return {
        'total': 0,
        'categories': 0,
        'lowStock': 0,
        'averagePrice': 0.0,
        'totalValue': 0.0,
      };
    }

    return {
      'total': totalProducts.value > 0 ? totalProducts.value : products.length,
      'categories': availableCategories.length - 1,
      'lowStock': products.where((p) => p.isLowStock).length,
      'outOfStock': products.where((p) => p.isOutOfStock).length,
      'averagePrice': products.map((p) => p.price).reduce((a, b) => a + b) / products.length,
      'totalValue': products.map((p) => p.stockValue).reduce((a, b) => a + b),
    };
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

// ========== SERVICE API FICTIF (remplacez par votre vrai service) ==========
