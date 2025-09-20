import 'package:examen_flutter/app/modules/product/controllers/add_product_controller.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
     Get.lazyPut<AddProductController>(
      () => AddProductController(),
    );
  }
}
