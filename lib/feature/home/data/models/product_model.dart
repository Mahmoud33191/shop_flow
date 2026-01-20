class ProductModel {
  final String id;
  final String? productCode;
  final String name;
  final String description;
  final String? arabicName;
  final String? arabicDescription;
  final double price;
  final String pictureUrl;
  final int stock;
  final String? color;
  final double rating;
  final int reviewsCount;
  final double discountPercentage;
  final List<String> categories;



  ProductModel({
    required this.id,
    this.productCode,
    required this.name,
    required this.description,
    this.arabicName,
    this.arabicDescription,
    required this.price,
    required this.pictureUrl,
    this.stock = 0,
    this.color,
    this.rating = 0,
    this.reviewsCount = 0,
    this.discountPercentage = 0,
    this.categories = const [],
  });

  /// Get categoryId from categories list (for filtering)
  int get categoryId {
    if (categories.isNotEmpty) {
      // Try to extract category index or hash
      return categories.first.hashCode;
    }
    return 0;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle categories which can be array of strings
    List<String> cats = [];
    if (json['categories'] != null && json['categories'] is List) {
      cats = (json['categories'] as List).map((c) => c.toString()).toList();
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      productCode: json['productCode'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      arabicName: json['arabicName'],
      arabicDescription: json['arabicDescription'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      pictureUrl: json['coverPictureUrl'] ?? json['pictureUrl'] ?? '',
      stock: json['stock'] ?? 0,
      color: json['color'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      categories: cats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'name': name,
      'description': description,
      'arabicName': arabicName,
      'arabicDescription': arabicDescription,
      'price': price,
      'coverPictureUrl': pictureUrl,
      'stock': stock,
      'color': color,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'discountPercentage': discountPercentage,
      'categories': categories,
    };
  }

  /// Check if product has discount
  bool get hasDiscount => discountPercentage > 0;

  /// Get discounted price
  double get discountedPrice => price * (1 - discountPercentage / 100);

  /// Check if in stock
  bool get inStock => stock > 0;
}
