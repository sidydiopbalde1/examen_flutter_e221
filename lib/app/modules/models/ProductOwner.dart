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