import 'package:flutter/material.dart';

class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final List<ProductImage> images;
  final ProductOwner? owner;
  final Color backgroundColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    this.images = const [],
    this.owner,
    required this.backgroundColor,
    this.createdAt,
    this.updatedAt,
  });

  // ========== FACTORY CONSTRUCTORS ==========

  /// Constructeur depuis la réponse de votre API
  factory Product.fromApiJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['nom'] ?? '',
      description: json['description'] ?? '',
      price: (json['prix'] ?? 0).toDouble(),
      category: json['categorie'] ?? '',
      stock: json['stock'] ?? 0,
      images: _parseImages(json['images']),
      owner: json['proprietaire'] != null 
          ? ProductOwner.fromJson(json['proprietaire'])
          : null,
      backgroundColor: _getRandomColor(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  /// Constructeur pour les données locales/fallback
  factory Product.fromLocalJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      stock: json['stock'] ?? 0,
      images: [],
      backgroundColor: _colorFromHex(json['background_color'] ?? '#E0E0E0'),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  /// Constructeur avec couleur hex
  Product.fromHexColor({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    this.images = const [],
    this.owner,
    required String backgroundColorHex,
    this.createdAt,
    this.updatedAt,
  }) : backgroundColor = _colorFromHex(backgroundColorHex);

  // ========== CONVERSION VERS API ==========

  /// Conversion vers format API pour création/mise à jour
  Map<String, dynamic> toApiJson() {
    return {
      'nom': name,
      'description': description,
      'prix': price,
      'categorie': category,
      'stock': stock,
    };
  }

  /// Conversion vers format local
  Map<String, dynamic> toLocalJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'stock': stock,
      'background_color': _colorToHex(backgroundColor),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // ========== METHODS ==========

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    int? stock,
    List<ProductImage>? images,
    ProductOwner? owner,
    Color? backgroundColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      owner: owner ?? this.owner,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ========== GETTERS ==========

  /// URL de la première image ou image par défaut
  String get imageUrl {
    if (images.isNotEmpty) {
      return images.first.url;
    }
    return 'default_product.png';
  }

  /// Prix minimum (pour compatibilité avec l'ancien modèle)
  double get minPrice => price;
  
  /// Prix maximum (pour compatibilité avec l'ancien modèle)
  double get maxPrice => price;

  /// Prix moyen (pour compatibilité)
  double get averagePrice => price;

  /// Couleur de fond en hex
  String get backgroundColorHex => _colorToHex(backgroundColor);

  /// Statut du stock
  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock < 10 && stock > 0;
  double get stockValue => stock * price;

  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  String get stockStatus {
    if (isOutOfStock) return 'Rupture de stock';
    if (isLowStock) return 'Stock faible';
    return 'En stock';
  }

  /// Couleur du texte selon la couleur de fond
  Color get textColor {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // ========== HELPER METHODS ==========

  static List<ProductImage> _parseImages(dynamic imagesData) {
    if (imagesData == null) return [];
    
    if (imagesData is List) {
      return imagesData
          .map((img) => ProductImage.fromJson(img))
          .toList();
    }
    
    return [];
  }

  static Color _colorFromHex(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.grey[200] ?? Color(0xFFE0E0E0);
    }
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  static Color _getRandomColor() {
    final colors = [
      Colors.deepPurpleAccent,
      Colors.orangeAccent,
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, price: $price, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ========== CLASSES AUXILIAIRES ==========

class ProductImage {
  final String filename;
  final String originalName;
  final String mimetype;
  final int size;
  final String url;
  final String? id;

  ProductImage({
    required this.filename,
    required this.originalName,
    required this.mimetype,
    required this.size,
    required this.url,
    this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      filename: json['filename'] ?? '',
      originalName: json['originalName'] ?? '',
      mimetype: json['mimetype'] ?? '',
      size: json['size'] ?? 0,
      url: json['url'] ?? '',
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'originalName': originalName,
      'mimetype': mimetype,
      'size': size,
      'url': url,
      if (id != null) '_id': id,
    };
  }
}

class ProductOwner {
  final String id;
  final String name;
  final String email;

  ProductOwner({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ProductOwner.fromJson(Map<String, dynamic> json) {
    return ProductOwner(
      id: json['_id'] ?? '',
      name: json['nom'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nom': name,
      'email': email,
    };
  }
}

// ========== EXTENSIONS ==========

extension ProductListExtension on List<Product> {
  List<Product> byCategory(String category) {
    return where((product) => product.category == category).toList();
  }

  List<Product> get outOfStock {
    return where((product) => product.isOutOfStock).toList();
  }

  List<Product> get lowStock {
    return where((product) => product.isLowStock).toList();
  }

  List<Product> sortByName({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name));
    return sorted;
  }

  List<Product> sortByPrice({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
    return sorted;
  }

  List<Product> sortByStock({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.stock.compareTo(b.stock)
        : b.stock.compareTo(a.stock));
    return sorted;
  }

  List<Product> search(String query) {
    if (query.isEmpty) return this;
    return where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Map<String, dynamic> get stats {
    if (isEmpty) {
      return {
        'total': 0,
        'categories': 0,
        'averagePrice': 0.0,
        'totalValue': 0.0,
        'outOfStock': 0,
        'lowStock': 0,
      };
    }

    return {
      'total': length,
      'categories': map((p) => p.category).toSet().length,
      'averagePrice': map((p) => p.price).reduce((a, b) => a + b) / length,
      'totalValue': map((p) => p.stockValue).reduce((a, b) => a + b),
      'outOfStock': outOfStock.length,
      'lowStock': lowStock.length,
    };
  }
}