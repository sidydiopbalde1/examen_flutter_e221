// Modèle de produit
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double minPrice;
  final double maxPrice;
  final String imageUrl;
  final int stock;
  final Color backgroundColor;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.minPrice,
    required this.maxPrice,
    required this.imageUrl,
    required this.stock,
    required this.backgroundColor,
  });
}