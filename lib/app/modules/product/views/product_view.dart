import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/product/controllers/add_product_controller.dart';
import 'package:examen_flutter/app/modules/product/controllers/product_controller.dart';
import 'package:examen_flutter/app/modules/product/views/edit_product_modal.dart';
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
                      child: _buildMainContent(constraints),
                    ),
                  ],
                );
              } else {
                // Mobile layout - show only main content with drawer
                return _buildMainContent(constraints);
              }
            },
          ),
        ),
      ),
      // Bouton flottant pour ajouter un produit
     
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
                  _buildNavItem(Icons.inventory_2_outlined, 'Product', false),
                  
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
                  
                  // Footer section avec statistiques
                  _buildStatsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Obx(() {
      final stats = controller.productStats;
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            
            // Total produits
            _buildStatItem(
              icon: Icons.inventory_2,
              label: 'Total produits',
              value: '${stats['total']}',
              color: Color(0xFF6F42C1),
            ),
            
            SizedBox(height: 8),
            
            // Stock faible
            _buildStatItem(
              icon: Icons.warning,
              label: 'Stock faible',
              value: '${stats['lowStock']}',
              color: Colors.orange,
            ),
            
            SizedBox(height: 8),
            
            // Rupture de stock
            _buildStatItem(
              icon: Icons.error,
              label: 'Rupture stock',
              value: '${stats['outOfStock']}',
              color: Colors.red,
            ),
            
            SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () => controller.refreshProducts(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6F42C1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Actualiser',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

  Widget _buildMainContent(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Header with title and actions
          Row(
            children: [
              Text(
                'Produits',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              
              // Filtres de catégorie
              Obx(() => Container(
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: controller.selectedCategory.value,
                  onChanged: (value) => controller.changeCategory(value!),
                  underline: Container(),
                  items: controller.availableCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category == 'Group' ? 'Toutes catégories' : category,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                ),
              )),
              
              SizedBox(width: 12),
              
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
                    hintText: 'Rechercher...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Add Product button
              Container(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddProductModal(Get.context!),
                  icon: Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    'Ajouter',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF6F42C1),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Chargement des produits...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun produit trouvé',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Commencez par ajouter votre premier produit',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddProductModal(Get.context!),
                        icon: Icon(Icons.add),
                        label: Text('Ajouter un produit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6F42C1),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 1200 ? 4 : 
                                constraints.maxWidth > 800 ? 3 : 2,
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
                        child: product.images.isNotEmpty
                            ? Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultProductIcon(product.category);
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: Color(0xFF6F42C1),
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              )
                            : _buildDefaultProductIcon(product.category),
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
                    
                    if (product.description.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    Spacer(),
                    
                    // Price and stock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFF6F42C1),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
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

  Widget _buildDefaultProductIcon(String category) {
    IconData iconData;
    switch (category.toLowerCase()) {
      case 'electronique':
        iconData = Icons.phone_android;
        break;
      case 'maison':
        iconData = Icons.home;
        break;
      case 'vetements':
        iconData = Icons.checkroom;
        break;
      case 'sport':
        iconData = Icons.sports_soccer;
        break;
      case 'livre':
        iconData = Icons.book;
        break;
      case 'sante':
        iconData = Icons.local_hospital;
        break;
      case 'beaute':
        iconData = Icons.face;
        break;
      case 'automobile':
        iconData = Icons.directions_car;
        break;
      case 'jardin':
        iconData = Icons.grass;
        break;
      case 'jouets':
        iconData = Icons.toys;
        break;
      case 'alimentaire':
        iconData = Icons.restaurant;
        break;
      case 'bricolage':
        iconData = Icons.build;
        break;
      default:
        iconData = Icons.inventory_2;
    }
    
    return Icon(
      iconData,
      size: 32,
      color: Colors.grey[400],
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
          // En-tête avec info produit
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: product.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: product.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultProductIcon(product.category);
                            },
                          ),
                        )
                      : _buildDefaultProductIcon(product.category),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6F42C1),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: product.stockStatusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stock: ${product.stock}',
                              style: TextStyle(
                                color: product.stockStatusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Actions
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.orange, size: 20),
            ),
            title: Text('Modifier le produit'),
            subtitle: Text('Changer les informations du produit'),
            onTap: () {
              Get.back();
              _showEditProductModal(product);
            },
          ),
          
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.inventory, color: Colors.blue, size: 20),
            ),
            title: Text('Gérer le stock'),
            subtitle: Text('Modifier la quantité en stock'),
            onTap: () {
              Get.back();
              _showStockDialog(product);
            },
          ),
          
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
            title: Text('Supprimer'),
            subtitle: Text('Supprimer définitivement ce produit'),
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

// Ajoutez cette nouvelle méthode pour afficher le modal de modification
void _showEditProductModal(Product product) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EditProductModal(product: product),
  );
}

void _handleProductAction(String action, Product product) {
  switch (action) {
    case 'edit':
      _showEditProductModal(product);
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
                suffixText: 'unités',
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
              } else {
                _showErrorSnackbar('Veuillez saisir un nombre valide');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6F42C1),
            ),
            child: Text('Confirmer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInfoSnackbar(String message) {
    Get.snackbar(
      'Information',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue[100],
      colorText: Colors.blue[800],
      duration: Duration(seconds: 3),
      icon: Icon(Icons.info, color: Colors.blue[800]),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
      duration: Duration(seconds: 3),
      icon: Icon(Icons.error, color: Colors.red[800]),
    );
  }
}

// Modal d'ajout de produit adapté
class AddProductModal extends StatelessWidget {
  final AddProductController controller = Get.put(AddProductController());

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
                    controller.buildSubmitButton(),
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
              color: Color(0xFF6F42C1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.add_shopping_cart,
              color: Color(0xFF6F42C1),
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nouveau produit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Ajoutez un nouveau produit à votre catalogue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
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
            Icon(Icons.image, color: Color(0xFF6F42C1), size: 20),
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
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF6F42C1), size: 20),
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
              borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
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
              borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
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
            Icon(Icons.attach_money, color: Color(0xFF6F42C1), size: 20),
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
                    borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
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
                    borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
                  ),
                ),
                validator: controller.validateStock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}