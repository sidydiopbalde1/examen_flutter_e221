import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';


class ProductController extends GetxController with GetSingleTickerProviderStateMixin {
  // ========== VARIABLES EXISTANTES ==========
  RxList<Product> products = <Product>[].obs;
  RxString selectedCategory = 'Group'.obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  // ========== NOUVELLES VARIABLES API ==========
  RxBool isCreating = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isDeleting = false.obs;
  RxString errorMessage = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMoreProducts = true.obs;

  // Filtres et tri
  RxString sortBy = 'name'.obs;
  RxString sortOrder = 'asc'.obs;
  RxList<String> availableCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeServices();
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

  void _initializeServices() {
    // Observer les changements du service API
    // ever(repository.isLoading, (loading) => isLoading.value = loading);
  }

  // ========== CHARGEMENT DES PRODUITS ==========
  
  Future<void> loadProducts({
    bool refresh = false,
    bool useCache = true,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await repository.getAllProducts(
        page: currentPage.value,
        limit: 20,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        category: selectedCategory.value != 'Group' ? selectedCategory.value : null,
        useCache: useCache && !refresh,
      );

      if (response.isSuccess && response.data != null) {
        if (refresh || currentPage.value == 1) {
          products.clear();
        }
        products.addAll(response.data!);
        
        _updateAvailableCategories();
        hasMoreProducts.value = response.data!.length >= 20;
      } else {
        errorMessage.value = response.message;
        _loadFallbackData();
      }
      */

      // FALLBACK: Utiliser vos données actuelles si l'API n'est pas disponible
      _loadFallbackData();

    } catch (e) {
      errorMessage.value = 'Erreur de connexion: $e';
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFallbackData() {
    products.value = [
      Product(
        id: '1',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 45.00,
        maxPrice: 55.00,
        imageUrl: 'image1.png',
        stock: 57,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      Product(
        id: '2',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 65.00,
        maxPrice: 85.00,
        imageUrl: 'image2.png',
        stock: 57,
        backgroundColor: Colors.orangeAccent,
      ),
      Product(
        id: '3',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 48.00,
        maxPrice: 65.00,
        imageUrl: 'image1.png',
        stock: 57,
        backgroundColor: Colors.red,
      ),
      Product(
        id: '4',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 45.00,
        maxPrice: 55.00,
        imageUrl: 'image3.png',
        stock: 57,
        backgroundColor: Colors.yellow,
      ),
      Product(
        id: '5',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 45.00,
        maxPrice: 65.00,
        imageUrl: 'image1.png',
        stock: 57,
        backgroundColor: Colors.black26,
      ),
      Product(
        id: '6',
        name: 'Amazon Echo Plus (3nd Gen)',
        category: 'Premium Quality',
        minPrice: 45.00,
        maxPrice: 65.00,
        imageUrl: 'image3.png',
        stock: 57,
        backgroundColor: Colors.green,
      ),
    ];
    _updateAvailableCategories();
  }

  // ========== OPÉRATIONS CRUD - AJOUT AMÉLIORÉ ==========

  /// Créer un nouveau produit (version améliorée avec validation)
  Future<bool> createProduct(Product product) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      // Validation des données avant envoi
      if (!_validateProduct(product)) {
        return false;
      }

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await repository.createProduct(product);
      
      if (response.isSuccess && response.data != null) {
        products.add(response.data!);
        _updateAvailableCategories();
        
        _showSuccessSnackbar('Produit créé avec succès');
        return true;
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar('Erreur lors de la création: ${response.message}');
        return false;
      }
      */

      // SIMULATION: Ajouter localement pour le moment
      await Future.delayed(Duration(seconds: 1)); // Simulation délai réseau

      final newProduct = product.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      
      products.add(newProduct);
      _updateAvailableCategories();
      
      _showSuccessSnackbar('Produit créé avec succès');
      return true;

    } catch (e) {
      errorMessage.value = 'Erreur lors de la création: $e';
      _showErrorSnackbar('Erreur lors de la création: $e');
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  /// Créer un produit depuis les données du formulaire
  Future<bool> createProductFromForm({
    required String name,
    required String category,
    required double minPrice,
    required double maxPrice,
    required int stock,
    required String backgroundColorHex,
    String? imageUrl,
    File? imageFile,
  }) async {
    try {
      // Créer le produit avec les données du formulaire
      final product = Product.fromHexColor(
        name: name.trim(),
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        imageUrl: imageUrl ?? 'default_product.png',
        stock: stock,
        backgroundColorHex: backgroundColorHex,
      );

      // Si une image a été sélectionnée, l'uploader d'abord
      if (imageFile != null) {
        final uploadedImageUrl = await _uploadImageFile(imageFile);
        if (uploadedImageUrl != null) {
          final updatedProduct = product.copyWith(imageUrl: uploadedImageUrl);
          return await createProduct(updatedProduct);
        }
      }

      return await createProduct(product);
    } catch (e) {
      _showErrorSnackbar('Erreur lors de la création du produit: $e');
      return false;
    }
  }

  /// Validation des données produit
  bool _validateProduct(Product product) {
    // Validation du nom
    if (product.name.trim().isEmpty) {
      _showErrorSnackbar('Le nom du produit est requis');
      return false;
    }

    // Validation du prix
    if (product.minPrice < 0 || product.maxPrice < 0) {
      _showErrorSnackbar('Les prix ne peuvent pas être négatifs');
      return false;
    }

    if (product.maxPrice < product.minPrice) {
      _showErrorSnackbar('Le prix maximum doit être supérieur au prix minimum');
      return false;
    }

    // Validation du stock
    if (product.stock < 0) {
      _showErrorSnackbar('Le stock ne peut pas être négatif');
      return false;
    }

    // Vérifier si le produit existe déjà (par nom)
    final existingProduct = products.firstWhereOrNull(
      (p) => p.name.toLowerCase().trim() == product.name.toLowerCase().trim(),
    );
    
    if (existingProduct != null) {
      _showErrorSnackbar('Un produit avec ce nom existe déjà');
      return false;
    }

    return true;
  }

  /// Upload d'image et retour de l'URL
  Future<String?> _uploadImageFile(File imageFile) async {
    try {
      // TODO: Implémenter l'upload réel vers votre serveur
      /*
      final multipartFile = await MultipartFile.fromPath(
        'image',
        imageFile.path,
      );

      final response = await productService.uploadProductImage('temp', multipartFile);
      
      if (response.isSuccess && response.data != null) {
        return response.data!;
      }
      */

      // SIMULATION: Retourner un nom de fichier simulé
      await Future.delayed(Duration(milliseconds: 500));
      return 'uploaded_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      
    } catch (e) {
      _showErrorSnackbar('Erreur lors de l\'upload de l\'image: $e');
      return null;
    }
  }

  // ========== AUTRES OPÉRATIONS CRUD (INCHANGÉES) ==========

  /// Mettre à jour un produit
  Future<void> updateProduct(String id, Product updatedProduct) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      // SIMULATION: Mettre à jour localement
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct.copyWith(
          id: id,
          updatedAt: DateTime.now(),
        );
        
        _showSuccessSnackbar('Produit mis à jour avec succès');
      }

    } catch (e) {
      errorMessage.value = 'Erreur lors de la mise à jour: $e';
      _showErrorSnackbar('Erreur lors de la mise à jour: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  /// Supprimer un produit
  Future<void> deleteProduct(String id) async {
    try {
      isDeleting.value = true;
      errorMessage.value = '';

      // Confirmation avant suppression
      final confirmed = await _showDeleteConfirmation();
      if (!confirmed) return;

      // SIMULATION: Supprimer localement
      products.removeWhere((p) => p.id == id);
      _updateAvailableCategories();
      
      _showSuccessSnackbar('Produit supprimé avec succès');

    } catch (e) {
      errorMessage.value = 'Erreur lors de la suppression: $e';
      _showErrorSnackbar('Erreur lors de la suppression: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  /// Dialogue de confirmation de suppression
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

  /// Mettre à jour le stock d'un produit
  Future<void> updateProductStock(String id, int newStock) async {
    try {
      if (newStock < 0) {
        _showErrorSnackbar('Le stock ne peut pas être négatif');
        return;
      }

      // SIMULATION: Mettre à jour le stock localement
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = products[index].copyWith(
          stock: newStock,
          updatedAt: DateTime.now(),
        );
        
        _showSuccessSnackbar('Stock mis à jour: $newStock');
      }

    } catch (e) {
      _showErrorSnackbar('Erreur lors de la mise à jour du stock: $e');
    }
  }

  /// Upload d'image pour un produit existant
  Future<void> uploadProductImage(String productId, File imageFile) async {
    try {
      isLoading.value = true;

      final uploadedImageUrl = await _uploadImageFile(imageFile);
      
      if (uploadedImageUrl != null) {
        final index = products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          products[index] = products[index].copyWith(
            imageUrl: uploadedImageUrl,
            updatedAt: DateTime.now(),
          );
          
          _showSuccessSnackbar('Image uploadée avec succès');
        }
      }

    } catch (e) {
      _showErrorSnackbar('Erreur lors de l\'upload d\'image: $e');
    } finally {
      isLoading.value = false;
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

  void sortProducts(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts.value || isLoading.value) return;
    
    currentPage.value++;
    await loadProducts();
  }

  Future<void> refreshProducts() async {
    currentPage.value = 1;
    await loadProducts(refresh: true, useCache: false);
  }

  // ========== FILTRES ET HELPERS ==========

  List<Product> get filteredProducts {
    var filtered = products.where((product) {
      final matchesSearch = searchQuery.value.isEmpty || 
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'Group' || 
          product.category == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();

    // Tri local
    switch (sortBy.value) {
      case 'name':
        filtered.sort((a, b) => sortOrder.value == 'asc' 
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'price':
        filtered.sort((a, b) => sortOrder.value == 'asc'
            ? a.minPrice.compareTo(b.minPrice)
            : b.minPrice.compareTo(a.minPrice));
        break;
      case 'stock':
        filtered.sort((a, b) => sortOrder.value == 'asc'
            ? a.stock.compareTo(b.stock)
            : b.stock.compareTo(a.stock));
        break;
      case 'date':
        filtered.sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return sortOrder.value == 'asc'
              ? aDate.compareTo(bDate)
              : bDate.compareTo(aDate);
        });
        break;
    }

    return filtered;
  }

  void _updateAvailableCategories() {
    final categories = products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'Group'); // Ajouter "Tous" en premier
    availableCategories.value = categories;
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
        'recentlyAdded': 0,
      };
    }

    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    return {
      'total': products.length,
      'categories': availableCategories.length - 1, // -1 pour exclure "Group"
      'lowStock': products.where((p) => p.isLowStock).length,
      'outOfStock': products.where((p) => p.isOutOfStock).length,
      'averagePrice': products.map((p) => p.averagePrice).reduce((a, b) => a + b) / products.length,
      'totalValue': products.map((p) => p.stockValue).reduce((a, b) => a + b),
      'recentlyAdded': products.where((p) => 
          p.createdAt != null && p.createdAt!.isAfter(weekAgo)
      ).length,
    };
  }

  // ========== UTILITAIRES ==========

  /// Obtenir un produit par ID
  Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Vérifier si un nom de produit existe déjà
  bool productNameExists(String name) {
    return products.any((p) => 
        p.name.toLowerCase().trim() == name.toLowerCase().trim()
    );
  }

  /// Obtenir les catégories disponibles (sans "Group")
  List<String> get realCategories {
    return availableCategories.where((cat) => cat != 'Group').toList();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

// ========== EXTENSIONS UTILES ==========

extension ProductExtension on Product {
  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock < 10 && stock > 0;
  double get averagePrice => (minPrice + maxPrice) / 2;
  double get stockValue => stock * minPrice;
  
  String get stockStatusText {
    if (isOutOfStock) return 'Rupture de stock';
    if (isLowStock) return 'Stock faible';
    return 'En stock';
  }
  
  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }
}