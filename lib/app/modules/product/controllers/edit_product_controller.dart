import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProductController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  
  RxBool isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString selectedCategory = 'electronique'.obs;
  RxString currentImageUrl = ''.obs;
  
  // Produit en cours de modification
  late Product originalProduct;

  // Catégories disponibles
  final List<String> categories = [
    'electronique',
    'maison',
    'vetements',
    'sport',
    'livre',
    'sante',
    'beaute',
    'automobile',
    'jardin',
    'jouets',
    'alimentaire',
    'bricolage',
  ];

  // Initialiser avec un produit existant
  void initializeWithProduct(Product product) {
    originalProduct = product;
    
    // Pré-remplir les champs
    nameController.text = product.name;
    descriptionController.text = product.description;
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    selectedCategory.value = product.category;
    currentImageUrl.value = product.imageUrl;
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        _showSuccess('Nouvelle image sélectionnée');
      }
    } catch (e) {
      print('🔍 [EDIT_PRODUCT] Erreur sélection image: $e');
      _showError('Impossible de sélectionner l\'image: $e');
    }
  }

  Future<void> updateProduct() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // Récupérer le contrôleur de produits
      final productController = Get.find<ProductController>();
      
      // Valider et préparer les données
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();
      final price = double.tryParse(priceController.text);
      final stock = int.tryParse(stockController.text);

      if (price == null || price <= 0) {
        _showError('Le prix doit être un nombre positif');
        return;
      }

      if (stock == null || stock < 0) {
        _showError('Le stock doit être un nombre positif ou zéro');
        return;
      }

      print('🔍 [EDIT_PRODUCT] Modification produit: $name, $price, $stock');

      // Créer le produit mis à jour
      final updatedProduct = originalProduct.copyWith(
        name: name,
        description: description,
        price: price,
        category: selectedCategory.value,
        stock: stock,
        updatedAt: DateTime.now(),
      );

      // Si une nouvelle image est sélectionnée, l'uploader d'abord
      if (selectedImage.value != null) {
        print('🔍 [EDIT_PRODUCT] Upload de la nouvelle image...');
        // TODO: Implémenter l'upload de la nouvelle image
        // final uploadSuccess = await _uploadProductImage(selectedImage.value!);
        // if (!uploadSuccess) {
        //   _showError('Erreur lors de l\'upload de l\'image');
        //   return;
        // }
      }

      // Appeler la méthode de mise à jour
      final success = await productController.updateProduct(
        originalProduct.id!,
        updatedProduct,
      );

      if (success) {
        _showSuccess('Produit modifié avec succès !');
        Get.back(); // Fermer le modal
      } else {
        _showError('Erreur lors de la modification du produit');
      }

    } catch (e) {
      print('🔍 [EDIT_PRODUCT] Erreur modification: $e');
      _showError('Erreur inattendue: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ========== VALIDATION ==========

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom du produit est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.trim().length > 100) {
      return 'Le nom ne peut pas dépasser 100 caractères';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le prix est requis';
    }
    
    final price = double.tryParse(value);
    if (price == null) {
      return 'Veuillez saisir un prix valide';
    }
    
    if (price <= 0) {
      return 'Le prix doit être supérieur à 0';
    }
    
    if (price > 999999) {
      return 'Le prix ne peut pas dépasser 999,999';
    }
    
    return null;
  }

  String? validateStock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le stock est requis';
    }
    
    final stock = int.tryParse(value);
    if (stock == null) {
      return 'Veuillez saisir un stock valide';
    }
    
    if (stock < 0) {
      return 'Le stock ne peut pas être négatif';
    }
    
    if (stock > 999999) {
      return 'Le stock ne peut pas dépasser 999,999';
    }
    
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La description est requise';
    }
    if (value.trim().length > 500) {
      return 'La description ne peut pas dépasser 500 caractères';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner une catégorie';
    }
    if (!categories.contains(value)) {
      return 'Catégorie invalide';
    }
    return null;
  }

  // ========== UI BUILDERS ==========

  Widget buildImagePreview() {
    return Obx(() {
      // Si une nouvelle image est sélectionnée
      if (selectedImage.value != null) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  selectedImage.value!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => selectedImage.value = null,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      }
      
      // Afficher l'image actuelle ou placeholder
      return GestureDetector(
        onTap: pickImage,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: currentImageUrl.value.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    children: [
                      Image.network(
                        currentImageUrl.value,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
                              SizedBox(height: 8),
                              Text('Image non disponible', style: TextStyle(color: Colors.grey[600])),
                            ],
                          );
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                    SizedBox(height: 12),
                    Text(
                      'Appuyez pour changer l\'image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget buildCategorySelector() {
    return Obx(() => DropdownButtonFormField<String>(
      value: selectedCategory.value,
      decoration: InputDecoration(
        labelText: 'Catégorie *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(Icons.category),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              _getCategoryIcon(category),
              SizedBox(width: 8),
              Text(_getCategoryDisplayName(category)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          selectedCategory.value = value;
        }
      },
      validator: validateCategory,
    ));
  }

  Widget buildUpdateButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading.value ? null : updateProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6F42C1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: isLoading.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Modification en cours...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Modifier le produit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    ));
  }

  Widget buildValidationIndicator() {
    return Obx(() {
      final validations = {
        'Nom': validateName(nameController.text) == null,
        'Prix': validatePrice(priceController.text) == null,
        'Stock': validateStock(stockController.text) == null,
        'Description': validateDescription(descriptionController.text) == null,
        'Catégorie': validateCategory(selectedCategory.value) == null,
      };
      
      final validCount = validations.values.where((isValid) => isValid).length;
      final totalCount = validations.length;
      
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: validCount == totalCount ? Colors.green[50] : Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: validCount == totalCount ? Colors.green[200]! : Colors.orange[200]!,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  validCount == totalCount ? Icons.check_circle : Icons.info,
                  color: validCount == totalCount ? Colors.green[600] : Colors.orange[600],
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  validCount == totalCount 
                      ? 'Formulaire prêt pour modification'
                      : 'Progression: $validCount/$totalCount',
                  style: TextStyle(
                    color: validCount == totalCount ? Colors.green[700] : Colors.orange[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (validCount < totalCount) ...[
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: validations.entries.map((entry) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: entry.value ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: entry.value ? Colors.green[700] : Colors.red[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ========== HELPERS ==========

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'electronique':
        return Icon(Icons.phone_android, size: 18);
      case 'maison':
        return Icon(Icons.home, size: 18);
      case 'vetements':
        return Icon(Icons.checkroom, size: 18);
      case 'sport':
        return Icon(Icons.sports_soccer, size: 18);
      case 'livre':
        return Icon(Icons.book, size: 18);
      case 'sante':
        return Icon(Icons.local_hospital, size: 18);
      case 'beaute':
        return Icon(Icons.face, size: 18);
      case 'automobile':
        return Icon(Icons.directions_car, size: 18);
      case 'jardin':
        return Icon(Icons.grass, size: 18);
      case 'jouets':
        return Icon(Icons.toys, size: 18);
      case 'alimentaire':
        return Icon(Icons.restaurant, size: 18);
      case 'bricolage':
        return Icon(Icons.build, size: 18);
      default:
        return Icon(Icons.category, size: 18);
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'electronique':
        return 'Électronique';
      case 'maison':
        return 'Maison & Décoration';
      case 'vetements':
        return 'Vêtements & Mode';
      case 'sport':
        return 'Sport & Loisirs';
      case 'livre':
        return 'Livres & Médias';
      case 'sante':
        return 'Santé & Bien-être';
      case 'beaute':
        return 'Beauté & Cosmétiques';
      case 'automobile':
        return 'Automobile & Moto';
      case 'jardin':
        return 'Jardin & Extérieur';
      case 'jouets':
        return 'Jouets & Jeux';
      case 'alimentaire':
        return 'Alimentaire & Boissons';
      case 'bricolage':
        return 'Bricolage & Outils';
      default:
        return category[0].toUpperCase() + category.substring(1);
    }
  }

  void _showSuccess(String message) {
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

  void _showError(String message) {
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

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }
}