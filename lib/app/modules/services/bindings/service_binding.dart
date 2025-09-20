import 'package:examen_flutter/app/modules/repository/product_repository.dart';
import 'package:examen_flutter/app/modules/services/api_service.dart';
import 'package:examen_flutter/app/modules/services/product_service.dart';
import 'package:get/get.dart';

class ServiceBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<ProductService>(ProductService(), permanent: true);
    Get.put<ProductRepository>(ProductRepository(), permanent: true);
  }
}