
import 'package:examen_flutter/app/modules/models/ApiResponse.dart';
import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/services/api_service.dart';
import 'package:examen_flutter/app/modules/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show MultipartFile;

class ProductService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  String get _token => GetStorage().read('auth_token') ?? '';

  /// GET - Récupérer tous les produits
  Future<ApiResponse<List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      _apiService.currentOperation.value = 'Chargement des produits...';

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortOrder != null) 'sort_order': sortOrder,
      };

      final response = await _apiService.getRequest(
        'products',
        token: _token,
        queryParams: queryParams,
      );

      final apiResponse = ApiResponse<List<Product>>.fromMap(response);

      if (apiResponse.isSuccess) {
        final List<dynamic> productsJson = response['data']['products'] ?? response['data'] ?? [];
        final products = productsJson.map((json) => Product.fromJson(json)).toList();
        return ApiResponse<List<Product>>.fromMap(response, products);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<List<Product>>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors du chargement des produits: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// GET - Récupérer un produit par ID
  Future<ApiResponse<Product>> getProduct(String id) async {
    try {
      _apiService.currentOperation.value = 'Chargement du produit...';

      final response = await _apiService.getRequest(
        'products/$id',
        token: _token,
      );

      final apiResponse = ApiResponse<Product>.fromMap(response);

      if (apiResponse.isSuccess) {
        final product = Product.fromJson(response['data']);
        return ApiResponse<Product>.fromMap(response, product);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Product>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors du chargement du produit: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// POST - Créer un nouveau produit
  Future<ApiResponse<Product>> createProduct(Product product) async {
    try {
      _apiService.currentOperation.value = 'Création du produit...';

      final productData = product.toJson();
      productData['created_at'] = DateTime.now().toIso8601String();

      final response = await _apiService.postRequest(
        'products',
        productData,
        token: _token,
      );

      final apiResponse = ApiResponse<Product>.fromMap(response);

      if (apiResponse.isSuccess) {
        final createdProduct = Product.fromJson(response['data']);
        return ApiResponse<Product>.fromMap(response, createdProduct);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Product>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors de la création du produit: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// PUT - Mettre à jour un produit
  Future<ApiResponse<Product>> updateProduct(String id, Product product) async {
    try {
      _apiService.currentOperation.value = 'Mise à jour du produit...';

      final productData = product.toJson();
      productData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _apiService.putRequest(
        'products/$id',
        productData,
        token: _token,
      );

      final apiResponse = ApiResponse<Product>.fromMap(response);

      if (apiResponse.isSuccess) {
        final updatedProduct = Product.fromJson(response['data']);
        return ApiResponse<Product>.fromMap(response, updatedProduct);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Product>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors de la mise à jour du produit: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// DELETE - Supprimer un produit
  Future<ApiResponse<bool>> deleteProduct(String id) async {
    try {
      _apiService.currentOperation.value = 'Suppression du produit...';

      final response = await _apiService.deleteRequest(
        'products/$id',
        token: _token,
      );

      final apiResponse = ApiResponse<bool>.fromMap(response);

      if (apiResponse.isSuccess) {
        return ApiResponse<bool>.fromMap(response, true);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<bool>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors de la suppression du produit: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// PATCH - Mettre à jour le stock
  Future<ApiResponse<Product>> updateStock(String id, int newStock) async {
    try {
      _apiService.currentOperation.value = 'Mise à jour du stock...';

      final response = await _apiService.patchRequest(
        'products/$id/stock',
        {
          'stock': newStock,
          'updated_at': DateTime.now().toIso8601String(),
        },
        token: _token,
      );

      final apiResponse = ApiResponse<Product>.fromMap(response);

      if (apiResponse.isSuccess) {
        final updatedProduct = Product.fromJson(response['data']);
        return ApiResponse<Product>.fromMap(response, updatedProduct);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Product>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors de la mise à jour du stock: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// DELETE - Supprimer plusieurs produits
  Future<ApiResponse<bool>> deleteMultipleProducts(List<String> ids) async {
    try {
      _apiService.currentOperation.value = 'Suppression des produits...';

      final response = await _apiService.postRequest(
        'products/batch-delete',
        {'ids': ids},
        token: _token,
      );

      final apiResponse = ApiResponse<bool>.fromMap(response);

      if (apiResponse.isSuccess) {
        return ApiResponse<bool>.fromMap(response, true);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<bool>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors de la suppression des produits: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }

  /// POST - Upload d'image produit avec multipart
  // Future<ApiResponse<String>> uploadProductImage(
  //   String productId,
  //   http.MultipartFile imageFile,
  // ) async {
  //   try {
  //     _apiService.currentOperation.value = 'Upload de l\'image...';

  //     final response = await _apiService.postMultipartRequest(
  //       endpoint: 'products/$productId/image',
  //       fields: {'product_id': productId},
  //       files: [imageFile],
  //       token: _token,
  //     );

  //     final apiResponse = ApiResponse<String>.fromMap(response);

  //     if (apiResponse.isSuccess) {
  //       final imageUrl = response['data']['image_url'] ?? '';
  //       return ApiResponse<String>.fromMap(response, imageUrl);
  //     }

  //     return apiResponse;
  //   } catch (e) {
  //     return ApiResponse<String>(
  //       statusCode: 0,
  //       status: 'error',
  //       message: 'Erreur lors de l\'upload de l\'image: $e',
  //     );
  //   } finally {
  //     _apiService.currentOperation.value = '';
  //   }
  // }

  /// GET - Statistiques des produits
  Future<ApiResponse<Map<String, dynamic>>> getProductStats() async {
    try {
      _apiService.currentOperation.value = 'Chargement des statistiques...';

      final response = await _apiService.getRequest(
        'products/stats',
        token: _token,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromMap(response);

      if (apiResponse.isSuccess) {
        return ApiResponse<Map<String, dynamic>>.fromMap(response, response['data']);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        statusCode: 0,
        status: 'error',
        message: 'Erreur lors du chargement des statistiques: $e',
      );
    } finally {
      _apiService.currentOperation.value = '';
    }
  }
}
