
import 'package:flutter/material.dart';

class Product {
  final String? id;
  final String name;
  final String category;
  final double minPrice;
  final double maxPrice;
  final String imageUrl;
  final int stock;
  final Color backgroundColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.imageUrl,
    required this.stock,
    required this.backgroundColor,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      minPrice: (json['min_price'] ?? 0).toDouble(),
      maxPrice: (json['max_price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      stock: json['stock'] ?? 0,
      backgroundColor: _colorFromHex(json['background_color'] ?? '#E0E0E0'),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'min_price': minPrice,
      'max_price': maxPrice,
      'image_url': imageUrl,
      'stock': stock,
      'background_color': _colorToHex(backgroundColor),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? imageUrl,
    int? stock,
    Color? backgroundColor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ========== HELPER METHODS POUR CONVERSION COULEURS ==========

  /// Convertit une string hex en Color
  static Color _colorFromHex(String hexString) {
    try {
      // Supprimer le # si présent
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      // Couleur par défaut en cas d'erreur
      return Colors.grey[200] ?? Color(0xFFE0E0E0);
    }
  }

  /// Convertit une Color en string hex
  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // ========== CONSTRUCTORS UTILES ==========

  /// Constructeur avec couleur hex string
  Product.fromHexColor({
    this.id,
    required this.name,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.imageUrl,
    required this.stock,
    required String backgroundColorHex,
    this.createdAt,
    this.updatedAt,
  }) : backgroundColor = _colorFromHex(backgroundColorHex);

  // ========== GETTERS UTILES ==========

  /// Retourne la couleur en format hex
  String get backgroundColorHex => _colorToHex(backgroundColor);

  /// Vérifie si le produit est en rupture de stock
  bool get isOutOfStock => stock <= 0;
  
  /// Vérifie si le produit a un stock faible
  bool get isLowStock => stock < 10 && stock > 0;
  
  /// Prix moyen du produit
  double get averagePrice => (minPrice + maxPrice) / 2;
  
  /// Valeur totale en stock
  double get stockValue => stock * minPrice;

  /// Couleur du texte selon la couleur de fond (contraste)
  Color get textColor {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Statut du stock avec texte
  String get stockStatus {
    if (isOutOfStock) return 'Rupture de stock';
    if (isLowStock) return 'Stock faible';
    return 'En stock';
  }

  /// Couleur du statut du stock
  Color get stockStatusColor {
    if (isOutOfStock) return Colors.red;
    if (isLowStock) return Colors.orange;
    return Colors.green;
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, price: $minPrice-$maxPrice, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ========== EXTENSIONS UTILES ==========

extension ProductListExtension on List<Product> {
  /// Filtre les produits par catégorie
  List<Product> byCategory(String category) {
    return where((product) => product.category == category).toList();
  }

  /// Filtre les produits en rupture de stock
  List<Product> get outOfStock {
    return where((product) => product.isOutOfStock).toList();
  }

  /// Filtre les produits avec stock faible
  List<Product> get lowStock {
    return where((product) => product.isLowStock).toList();
  }

  /// Trie par nom
  List<Product> sortByName({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.name.compareTo(b.name)
        : b.name.compareTo(a.name));
    return sorted;
  }

  /// Trie par prix
  List<Product> sortByPrice({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.averagePrice.compareTo(b.averagePrice)
        : b.averagePrice.compareTo(a.averagePrice));
    return sorted;
  }

  /// Trie par stock
  List<Product> sortByStock({bool ascending = true}) {
    final sorted = List<Product>.from(this);
    sorted.sort((a, b) => ascending 
        ? a.stock.compareTo(b.stock)
        : b.stock.compareTo(a.stock));
    return sorted;
  }

  /// Recherche par nom
  List<Product> search(String query) {
    if (query.isEmpty) return this;
    return where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Statistiques de la liste
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
      'averagePrice': map((p) => p.averagePrice).reduce((a, b) => a + b) / length,
      'totalValue': map((p) => p.stockValue).reduce((a, b) => a + b),
      'outOfStock': outOfStock.length,
      'lowStock': lowStock.length,
    };
  }
}