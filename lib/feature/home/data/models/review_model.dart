class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String productId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] ?? json['userDisplayName'] ?? 'Anonymous',
      userPhoto: json['userPhoto'] ?? json['userPictureUrl'],
      productId: json['productId']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? json['reviewText'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class ReviewsResponse {
  final String? message;
  final double? averageRating;
  final int? reviewsCount;
  final List<ReviewModel> reviews;

  ReviewsResponse({
    this.message,
    this.averageRating,
    this.reviewsCount,
    required this.reviews,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    final reviewsList = json['reviews']?['items'] ?? json['reviews'] ?? [];
    return ReviewsResponse(
      message: json['message'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      reviews: (reviewsList as List)
          .map((r) => ReviewModel.fromJson(r))
          .toList(),
    );
  }
}
