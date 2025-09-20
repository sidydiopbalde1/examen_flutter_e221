import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' show MultipartFile;

// Importez vos services API
// import 'package:examen_flutter/app/services/product_service.dart';
// import 'package:examen_flutter/app/services/product_repository.dart';

class ProductController extends GetxController with GetSingleTickerProviderStateMixin {
  // ========== VARIABLES EXISTANTES ==========
  RxList<Product> products = <Product>[].obs;
  RxString selectedCategory = 'Group'.obs;
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  // ========== NOUVELLES VARIABLES API ==========
  // final ProductRepository repository = Get.find<ProductRepository>();
  // final ProductService productService = Get.find<ProductService>();
  
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
  
  /// Charge les produits depuis l'API ou utilise les données locales en fallback
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
        
        // Mettre à jour les catégories disponibles
        _updateAvailableCategories();
        
        // Gérer la pagination
        hasMoreProducts.value = response.data!.length >= 20;
      } else {
        errorMessage.value = response.message;
        _loadFallbackData(); // Utiliser les données locales en cas d'erreur
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

  /// Données de fallback (vos données actuelles)
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
        backgroundColor: Colors.deepPurpleAccent, // Conversion en String pour l'API
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
        backgroundColor:Colors.green,
      ),
    ];
    _updateAvailableCategories();
  }

  // ========== OPÉRATIONS CRUD ==========

  /// Créer un nouveau produit
  Future<void> createProduct(Product product) async {
    try {
      isCreating.value = true;
      errorMessage.value = '';

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await repository.createProduct(product);
      
      if (response.isSuccess && response.data != null) {
        products.add(response.data!);
        _updateAvailableCategories();
        
        Get.snackbar(
          'Succès',
          'Produit créé avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar('Erreur lors de la création: ${response.message}');
      }
      */

      // SIMULATION: Ajouter localement pour le moment
      final newProduct = product.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      products.add(newProduct);
      _updateAvailableCategories();
      
      Get.snackbar(
        'Succès',
        'Produit créé avec succès (simulation)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

    } catch (e) {
      errorMessage.value = 'Erreur lors de la création: $e';
      _showErrorSnackbar('Erreur lors de la création: $e');
    } finally {
      isCreating.value = false;
    }
  }

  /// Mettre à jour un produit
  Future<void> updateProduct(String id, Product updatedProduct) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await repository.updateProduct(id, updatedProduct);
      
      if (response.isSuccess && response.data != null) {
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = response.data!;
        }
        
        Get.snackbar(
          'Succès',
          'Produit mis à jour avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
        );
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar('Erreur lors de la mise à jour: ${response.message}');
      }
      */

      // SIMULATION: Mettre à jour localement
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = updatedProduct.copyWith(
          id: id,
          updatedAt: DateTime.now(),
        );
        
        Get.snackbar(
          'Succès',
          'Produit mis à jour avec succès (simulation)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue[100],
          colorText: Colors.blue[800],
        );
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
      final confirmed = await Get.dialog<bool>(
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

      if (!confirmed) return;

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await repository.deleteProduct(id);
      
      if (response.isSuccess) {
        products.removeWhere((p) => p.id == id);
        _updateAvailableCategories();
        
        Get.snackbar(
          'Succès',
          'Produit supprimé avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      } else {
        errorMessage.value = response.message;
        _showErrorSnackbar('Erreur lors de la suppression: ${response.message}');
      }
      */

      // SIMULATION: Supprimer localement
      products.removeWhere((p) => p.id == id);
      _updateAvailableCategories();
      
      Get.snackbar(
        'Succès',
        'Produit supprimé avec succès (simulation)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );

    } catch (e) {
      errorMessage.value = 'Erreur lors de la suppression: $e';
      _showErrorSnackbar('Erreur lors de la suppression: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  /// Mettre à jour le stock d'un produit
  Future<void> updateProductStock(String id, int newStock) async {
    try {
      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final response = await productService.updateStock(id, newStock);
      
      if (response.isSuccess && response.data != null) {
        final index = products.indexWhere((p) => p.id == id);
        if (index != -1) {
          products[index] = response.data!;
        }
      } else {
        _showErrorSnackbar('Erreur lors de la mise à jour du stock: ${response.message}');
      }
      */

      // SIMULATION: Mettre à jour le stock localement
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index] = products[index].copyWith(
          stock: newStock,
          updatedAt: DateTime.now(),
        );
        
        Get.snackbar(
          'Stock mis à jour',
          'Nouveau stock: $newStock',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
        );
      }

    } catch (e) {
      _showErrorSnackbar('Erreur lors de la mise à jour du stock: $e');
    }
  }

  /// Upload d'image pour un produit
  Future<void> uploadProductImage(String productId, File imageFile) async {
    try {
      isLoading.value = true;

      // TODO: Décommentez quand vous avez configuré vos services API
      /*
      final multipartFile = await MultipartFile.fromPath(
        'image',
        imageFile.path,
      );

      final response = await productService.uploadProductImage(productId, multipartFile);
      
      if (response.isSuccess && response.data != null) {
        // Mettre à jour l'URL de l'image du produit
        final index = products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          products[index] = products[index].copyWith(
            imageUrl: response.data!,
            updatedAt: DateTime.now(),
          );
        }
        
        Get.snackbar(
          'Succès',
          'Image uploadée avec succès',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        _showErrorSnackbar('Erreur lors de l\'upload: ${response.message}');
      }
      */

      // SIMULATION: Mise à jour locale de l'image
      final index = products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        products[index] = products[index].copyWith(
          imageUrl: 'uploaded_${imageFile.path.split('/').last}',
          updatedAt: DateTime.now(),
        );
        
        Get.snackbar(
          'Succès',
          'Image uploadée avec succès (simulation)',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      }

    } catch (e) {
      _showErrorSnackbar('Erreur lors de l\'upload d\'image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ========== RECHERCHE ET FILTRES ==========

  /// Rechercher des produits
  void searchProducts(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  /// Changer de catégorie
  void changeCategory(String category) {
    selectedCategory.value = category;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  /// Trier les produits
  void sortProducts(String field, String order) {
    sortBy.value = field;
    sortOrder.value = order;
    currentPage.value = 1;
    loadProducts(refresh: true);
  }

  /// Charger plus de produits (pagination)
  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts.value || isLoading.value) return;
    
    currentPage.value++;
    await loadProducts();
  }

  /// Rafraîchir les produits
  Future<void> refreshProducts() async {
    currentPage.value = 1;
    await loadProducts(refresh: true, useCache: false);
  }

  // ========== FILTRES ET HELPERS ==========

  /// Produits filtrés (votre logique existante + améliorations)
  List<Product> get filteredProducts {
    var filtered = products.where((product) {
      final matchesSearch = searchQuery.value.isEmpty || 
          product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'Group' || 
          product.category == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();

    // Tri local si pas d'API
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
    }

    return filtered;
  }

  void _updateAvailableCategories() {
    final categories = products.map((p) => p.category).toSet().toList();
    categories.insert(0, 'Group'); // Ajouter "Tous" en premier
    availableCategories.value = categories;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      duration: Duration(seconds: 4),
    );
  }

  // ========== STATISTIQUES ==========

  /// Obtenir des statistiques sur les produits
  Map<String, dynamic> get productStats {
    return {
      'total': products.length,
      'categories': availableCategories.length - 1, // -1 pour exclure "Group"
      'lowStock': products.where((p) => p.stock < 10).length,
      'averagePrice': products.isEmpty ? 0 : 
          products.map((p) => (p.minPrice + p.maxPrice) / 2).reduce((a, b) => a + b) / products.length,
      'totalValue': products.map((p) => p.stock * p.minPrice).reduce((a, b) => a + b),
    };
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

// ========== EXTENSIONS UTILES ==========

extension ProductExtension on Product {
  /// Vérifie si le produit est en rupture de stock
  bool get isOutOfStock => stock <= 0;
  
  /// Vérifie si le produit a un stock faible
  bool get isLowStock => stock < 10 && stock > 0;
  
  /// Prix moyen du produit
  double get averagePrice => (minPrice + maxPrice) / 2;
  
  /// Valeur totale en stock
  double get stockValue => stock * minPrice;
}