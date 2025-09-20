
import 'package:examen_flutter/app/modules/models/Product.dart';
import 'package:examen_flutter/app/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductView extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF6F42C1),
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
                  onChanged: (value) => controller.searchQuery.value = value,
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
                  onPressed: () {},
                  icon: Icon(Icons.add, size: 16, color: Colors.white),
                  label: Text(
                    'Add Group',
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
    return Container(
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
              child: Center(
                child: _buildProductIcon(product.imageUrl),
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
                      Text(
                        'Stock ${product.stock}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
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