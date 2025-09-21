import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/product/controllers/edit_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductModal extends StatelessWidget {
  final Product product;
  late final EditProductController controller;

  EditProductModal({Key? key, required this.product}) : super(key: key) {
    controller = Get.put(EditProductController());
    controller.initializeWithProduct(product);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    SizedBox(height: 24),
                    _buildBasicInfoSection(),
                    SizedBox(height: 24),
                    _buildPriceStockSection(),
                    SizedBox(height: 24),
                    controller.buildValidationIndicator(),
                    SizedBox(height: 32),
                    controller.buildUpdateButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.edit,
              color: Colors.orange,
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modifier le produit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Modifiez les informations de "${product.name}"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close, color: Colors.grey[600]),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Image du produit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        controller.buildImagePreview(),
        SizedBox(height: 8),
        Text(
          'Appuyez sur l\'image pour la modifier',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Informations de base',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        // Nom du produit
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom du produit *',
            hintText: 'Ex: iPhone 14 Pro Max',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(Icons.shopping_bag_outlined),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          validator: controller.validateName,
          textCapitalization: TextCapitalization.words,
        ),
        
        SizedBox(height: 16),
        
        // Catégorie
        controller.buildCategorySelector(),
        
        SizedBox(height: 16),
        
        // Description
        TextFormField(
          controller: controller.descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description *',
            hintText: 'Décrivez votre produit...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.description_outlined),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          validator: controller.validateDescription,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildPriceStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.attach_money, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Prix et inventaire',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        Row(
          children: [
            // Prix
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller.priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Prix *',
                  hintText: '0.00',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.price_change_outlined),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
                validator: controller.validatePrice,
              ),
            ),
            
            SizedBox(width: 16),
            
            // Stock
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: controller.stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock *',
                  hintText: '0',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.inventory_outlined),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
                validator: controller.validateStock,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Informations sur les modifications
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[600], size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produit créé le',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      product.createdAt?.toString().split(' ')[0] ?? 'Date inconnue',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (product.updatedAt != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Modifié',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Nettoyer le contrôleur quand le modal est fermé
    Get.delete<EditProductController>();
    // super.dispose();
  }
}