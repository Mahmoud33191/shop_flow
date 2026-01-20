class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String pictureUrl;
  final int categoryId; // This field is crucial for filtering.

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.pictureUrl,
    required this.categoryId,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // A common point of failure is if a key doesn't exist or has the wrong type.
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      pictureUrl: json['coverPictureUrl'],
      // The API's /Products endpoint must return a category identifier for filtering to work.
      // We assume it's 'categoryId'. If it's 'productTypeId', change it here.
      categoryId: json['categoryId'] ?? json['productTypeId'] ?? 0,
    );
  }
}