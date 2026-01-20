class OfferModel {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final double discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;

  OfferModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.discountPercentage,
    this.startDate,
    this.endDate,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
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
    );
  }
}
