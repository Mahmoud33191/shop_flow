class OfferModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final double discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? categoryId;
  final List<String> productIds;

  OfferModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.discountPercentage,
    this.startDate,
    this.endDate,
    this.categoryId,
    this.productIds = const [],
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    List<String> pIds = [];
    if (json['productIds'] != null && json['productIds'] is List) {
      pIds = (json['productIds'] as List).map((e) => e.toString()).toList();
    }

    return OfferModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['pictureUrl'],
      discountPercentage: (json['discountPercentage'] ?? json['discount'] ?? 0)
          .toDouble(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      categoryId: json['categoryId'],
      productIds: pIds,
    );
  }
}
