
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
      backgroundColor: Color(json['background_color'] ?? 0xFFE0E0E0),
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
      'id': id,
      'name': name,
      'category': category,
      'min_price': minPrice,
      'max_price': maxPrice,
      'image_url': imageUrl,
      'stock': stock,
      'background_color': backgroundColor.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
}