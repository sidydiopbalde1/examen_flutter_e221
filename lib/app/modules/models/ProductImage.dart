
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
