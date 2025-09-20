import 'package:examen_flutter/app/modules/models/ApiResponse.dart';
import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/services/product_service.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxService {
  final ProductService _productService = Get.find<ProductService>();
  
  // Cache local
  final RxList<Product> _cachedProducts = <Product>[].obs;
  final RxMap<String, Product> _productCache = <String, Product>{}.obs;
  
  List<Product> get cachedProducts => _cachedProducts.toList();

  Future<ApiResponse<List<Product>>> getAllProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    bool useCache = true,
  }) async {
    // Utiliser le cache si disponible
    if (useCache && _cachedProducts.isNotEmpty && page == 1 && search == null) {
      return ApiResponse<List<Product>>(
        statusCode: 200,
        status: 'success',
        message: 'Produits chargés depuis le cache',
        data: _cachedProducts.toList(),
      );
    }

    final response = await _productService.getProducts(
      page: page,
      limit: limit,
      search: search,
      category: category,
    );

    if (response.isSuccess && response.data != null) {
      if (page == 1) {
        _cachedProducts.clear();
      }
      _cachedProducts.addAll(response.data!);
      
      // Mettre à jour le cache individuel
      for (final product in response.data!) {
        if (product.id != null) {
          _productCache[product.id!] = product;
        }
      }
    }

    return response;
  }

  Future<ApiResponse<Product>> getProductById(String id) async {
    // Vérifier le cache d'abord
    if (_productCache.containsKey(id)) {
      return ApiResponse<Product>(
        statusCode: 200,
        status: 'success',
        message: 'Produit chargé depuis le cache',
        data: _productCache[id]!,
      );
    }

    final response = await _productService.getProduct(id);
    
    if (response.isSuccess && response.data != null) {
      _productCache[id] = response.data!;
    }

    return response;
  }

  Future<ApiResponse<Product>> createProduct(Product product) async {
    final response = await _productService.createProduct(product);
    
    if (response.isSuccess && response.data != null) {
      _cachedProducts.add(response.data!);
      if (response.data!.id != null) {
        _productCache[response.data!.id!] = response.data!;
      }
    }

    return response;
  }

  Future<ApiResponse<Product>> updateProduct(String id, Product product) async {
    final response = await _productService.updateProduct(id, product);
    
    if (response.isSuccess && response.data != null) {
      // Mettre à jour le cache
      final index = _cachedProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _cachedProducts[index] = response.data!;
      }
      _productCache[id] = response.data!;
    }

    return response;
  }

  Future<ApiResponse<bool>> deleteProduct(String id) async {
    final response = await _productService.deleteProduct(id);
    
    if (response.isSuccess) {
      // Supprimer du cache
      _cachedProducts.removeWhere((p) => p.id == id);
      _productCache.remove(id);
    }

    return response;
  }

  void clearCache() {
    _cachedProducts.clear();
    _productCache.clear();
  }

  void refreshCache() {
    getAllProducts(useCache: false);
  }
}