
import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/product/controllers/add_product_controller.dart';
import 'package:examen_flutter/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Desktop layout
                return Row(
                  children: [
                    Container(
                      width: 280,
                      child: _buildSidebar(),
                    ),
                    Expanded(
                      child: _buildMainContent(),
                    ),
                  ],
                );
              } else {
                // Mobile layout - show only main content with drawer
                return _buildMainContent();
              }
            },
          ),
        ),
      ),
      // Bouton flottant pour ajouter un produit
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductModal(context),
        backgroundColor: Color(0xFF6F42C1),
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text('Ajouter'),
      ),
    );
  }

  void _showAddProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductModal(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.apps, color: Colors.white, size: 18),
                ),
                SizedBox(width: 12),
                Text(
                  'Substance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildNavItem(Icons.grid_view_outlined, 'Overview', false),
                  _buildNavItem(Icons.inventory_2_outlined, 'Product', true),
                  
                  // Sub items for Product
                  Container(
                    margin: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                    child: Column(
                      children: [
                        _buildSubNavItem('All Products', false),
                        _buildSubNavItem('Categories', false),
                        _buildSubNavItem('Group', true),
                      ],
                    ),
                  ),
                  
                  _buildNavItem(Icons.shopping_cart_outlined, 'Orders', false),
                  _buildNavItem(Icons.people_outline, 'Customers', false),
                  _buildNavItem(Icons.rate_review_outlined, 'Manage Reviews', false),
                  _buildNavItem(Icons.shopping_bag_outlined, 'Checkout', false),
                  _buildNavItem(Icons.settings_outlined, 'Settings', false),
                  
                  Spacer(),
                  
                  // Footer section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Technical help',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Contact us',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Release you maximum potential with our potential software',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Warning stripe
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.yellow[600]!, Colors.black],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomPaint(
                            painter: StripePainter(),
                            child: Center(
                              child: Text(
                                'BOTTOM OVERFLOW BY 67 PIXELS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        Container(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6F42C1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Upgrade to Pro',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF6F42C1).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Color(0xFF6F42C1) : Colors.grey[600],
          size: 18,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Color(0xFF6F42C1) : Colors.grey[700],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        minLeadingWidth: 20,
      ),
    );
  }

  Widget _buildSubNavItem(String title, bool isActive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF6F42C1).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Color(0xFF6F42C1) : Colors.grey[600],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Header with title and actions
          Row(
            children: [
              Text(
                'Group',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              
              // Search bar
              Container(
                width: 200,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  onChanged: (value) => controller.searchProducts(value),
                  decoration: InputDecoration(
                    hintText: 'Search group...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Add Group button
              Container(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddProductModal(Get.context!),
                  icon: Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    'Add Product',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6F42C1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Products grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6F42C1),
                  ),
                );
              }
              
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return AnimatedBuilder(
                    animation: controller.fadeAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.fadeAnimation.value,
                        child: Opacity(
                          opacity: controller.fadeAnimation.value,
                          child: _buildProductCard(product),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductActions(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Product image container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: product.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/images/${product.imageUrl}',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 32,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      ),
                    ),
                    // Actions overlay
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white, size: 18),
                          onSelected: (value) => _handleProductAction(value, product),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Modifier'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'stock',
                              child: Row(
                                children: [
                                  Icon(Icons.inventory, size: 16),
                                  SizedBox(width: 8),
                                  Text('Gérer stock'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Supprimer', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '- ${product.category}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Price and stock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.minPrice.toStringAsFixed(2)} - \$${product.maxPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFF6F42C1),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.stockStatusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Stock ${product.stock}',
                            style: TextStyle(
                              color: product.stockStatusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductActions(Product product) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.edit, color: Color(0xFF6F42C1)),
              title: Text('Modifier le produit'),
              onTap: () {
                Get.back();
                // TODO: Implementer la modification
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory, color: Colors.orange),
              title: Text('Gérer le stock'),
              onTap: () {
                Get.back();
                _showStockDialog(product);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Supprimer'),
              onTap: () {
                Get.back();
                controller.deleteProduct(product.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleProductAction(String action, Product product) {
    switch (action) {
      case 'edit':
        // TODO: Implementer la modification
        break;
      case 'stock':
        _showStockDialog(product);
        break;
      case 'delete':
        controller.deleteProduct(product.id!);
        break;
    }
  }

  void _showStockDialog(Product product) {
    final stockController = TextEditingController(text: product.stock.toString());
    
    Get.dialog(
      AlertDialog(
        title: Text('Modifier le stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Produit: ${product.name}'),
            SizedBox(height: 16),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nouveau stock',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text);
              if (newStock != null) {
                controller.updateProductStock(product.id!, newStock);
                Get.back();
              }
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductIcon(String iconName) {
    IconData iconData;
    double size = 32;
    
    switch (iconName) {
      case 'speaker':
        iconData = Icons.speaker;
        break;
      case 'magnifier':
        iconData = Icons.search;
        break;
      case 'camera':
        iconData = Icons.camera_alt;
        break;
      case 'headphones':
        iconData = Icons.headphones;
        break;
      case 'watch':
        iconData = Icons.watch;
        break;
      case 'instant_camera':
        iconData = Icons.camera;
        break;
      default:
        iconData = Icons.device_unknown;
    }
    
    return Icon(
      iconData,
      size: size,
      color: Colors.black54,
    );
  }
}

// Modal d'ajout de produit
class AddProductModal extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Text(
                  'Ajouter un produit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    SizedBox(height: 24),
                    _buildBasicInfoSection(),
                    SizedBox(height: 24),
                    _buildPriceSection(),
                    SizedBox(height: 24),
                    _buildColorSection(),
                    SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
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
        Text(
          'Image du produit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Obx(() => GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: controller.selectedImage.value != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      controller.selectedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey[400]),
                      SizedBox(height: 8),
                      Text(
                        'Appuyez pour ajouter une image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
          ),
        )),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations de base',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        
        // Nom
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom du produit *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le nom est requis';
            }
            return null;
          },
        ),
        
        SizedBox(height: 16),
        
        // Catégorie
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedCategory.value,
          decoration: InputDecoration(
            labelText: 'Catégorie *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: controller.categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: (value) => controller.selectedCategory.value = value!,
        )),
        
        SizedBox(height: 16),
        
        // Stock
        TextFormField(
          controller: controller.stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stock *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Le stock est requis';
            if (int.tryParse(value) == null) return 'Nombre invalide';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gamme de prix',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        
        Row(
          children: [
            // Prix minimum
            Expanded(
              child: TextFormField(
                controller: controller.minPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Prix min *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Prix min requis';
                  if (double.tryParse(value) == null) return 'Prix invalide';
                  return null;
                },
              ),
            ),
            
            SizedBox(width: 16),
            
            // Prix maximum
            Expanded(
              child: TextFormField(
                controller: controller.maxPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Prix max *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Prix max requis';
                  final maxPrice = double.tryParse(value);
                  final minPrice = double.tryParse(controller.minPriceController.text);
                  
                  if (maxPrice == null) return 'Prix invalide';
                  if (minPrice != null && maxPrice < minPrice) {
                    return 'Prix max < prix min';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couleur de fond',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        
        Obx(() => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.backgroundColors.map((colorHex) {
            final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
            final isSelected = controller.selectedBackgroundColor.value == colorHex;
            
            return GestureDetector(
              onTap: () => controller.selectedBackgroundColor.value = colorHex,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Color(0xFF6F42C1) : Colors.grey[300]!,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.addProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6F42C1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Ajouter le produit',
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
}

// Custom painter for diagonal stripes
class StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    for (double i = -size.height; i < size.width; i += 8) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}