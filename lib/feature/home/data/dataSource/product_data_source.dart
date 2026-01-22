import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';
import 'package:shop_flow/core/network/api/end_points.dart';
import 'package:shop_flow/core/services/cache_service.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';
import 'package:shop_flow/feature/home/data/models/offer_model.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';
import 'package:shop_flow/feature/home/data/models/review_model.dart';

/// Abstract class defining the contract for product and category data operations.
abstract class IProductDataSource {
  Future<List<CategoryModel>> fetchCategories();
  Future<List<ProductModel>> fetchProducts({
    int? categoryId,
    String? searchQuery,
    int pageNumber = 1,
    int pageSize = 100,
  });
  Future<List<OfferModel>> fetchOffers();
  Future<ProductModel?> fetchProductById(String productId);
  Future<List<ReviewModel>> fetchProductReviews(String productId);
  Future<void> addProduct(Map<String, dynamic> productData);
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  });
}

/// Concrete implementation of the IProductDataSource using Dio.
class ProductDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductDataSource(this._apiService);

  // ... _extractErrorMessage method remains the same ...
  String _extractErrorMessage(DioException e, String defaultMessage) {
    final data = e.response?.data;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection.';
    }
    if (data == null) return defaultMessage;
    if (data is Map) {
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.map((e) => e.toString()).join(', ');
        } else if (errors is Map) {
          final allErrors = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              allErrors.addAll(value.map((e) => e.toString()));
            } else {
              allErrors.add(value.toString());
            }
          });
          if (allErrors.isNotEmpty) return allErrors.join(', ');
        }
      }
      if (data['message'] != null) return data['message'].toString();
      if (data['title'] != null) return data['title'].toString();
      if (data['error'] != null) return data['error'].toString();
    }
    return defaultMessage;
  }

  // ... fetchCategories method remains the same ...
  @override
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final token = CacheService.instance.accessToken;
      final Response response = await _apiService.get(
        EndPoints.categories,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((json) => CategoryModel.fromJson(json)).toList();
        } else if (response.data is Map && response.data['items'] != null) {
          final List<dynamic> data = response.data['items'];
          return data.map((json) => CategoryModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Categories fetch failed: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Categories error: $e');
      return [];
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts({
    int? categoryId,
    String? searchQuery,
    int pageNumber = 1,
    int pageSize = 100,
  }) async {
    try {
      // Build query parameters dynamically
      final queryParameters = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      if (categoryId != null) {
        queryParameters['categoryId'] = categoryId;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['name'] = searchQuery;
      }

      final token = CacheService.instance.accessToken;
      final Response response = await _apiService.get(
        EndPoints.products,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        if (response.data is Map && response.data['items'] != null) {
          final List<dynamic> data = response.data['items'];
          return data.map((json) => ProductModel.fromJson(json)).toList();
        } else if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((json) => ProductModel.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load products');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return [];
      }
      throw Exception(_extractErrorMessage(e, 'Failed to load products'));
    } catch (e) {
      if (e is FormatException) {
        return [];
      }
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // ... all other methods (fetchOffers, fetchProductById, etc.) remain unchanged ...
  @override
  Future<List<OfferModel>> fetchOffers() async {
    try {
      final token = CacheService.instance.accessToken;
      final Response response = await _apiService.get(
        EndPoints.offers,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((json) => OfferModel.fromJson(json)).toList();
        } else if (response.data is Map && response.data['items'] != null) {
          final List<dynamic> data = response.data['items'];
          return data.map((json) => OfferModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Offers fetch failed: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Offers fetch error: $e');
      return [];
    }
  }

  @override
  Future<ProductModel?> fetchProductById(String productId) async {
    try {
      final token = CacheService.instance.accessToken;
      final Response response = await _apiService.get(
        EndPoints.productById(productId),
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return null;
      }
      throw Exception(
        _extractErrorMessage(e, 'Failed to load product details'),
      );
    } catch (e) {
      if (e is FormatException) {
        return null;
      }
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ReviewModel>> fetchProductReviews(String productId) async {
    try {
      final token = CacheService.instance.accessToken;
      final Response response = await _apiService.get(
        EndPoints.reviews(productId),
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          final List<dynamic> data = response.data;
          return data.map((json) => ReviewModel.fromJson(json)).toList();
        } else if (response.data is Map && response.data['items'] != null) {
          final List<dynamic> data = response.data['items'];
          return data.map((json) => ReviewModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint('Reviews fetch failed: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Reviews fetch error: $e');
      return [];
    }
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final token = CacheService.instance.accessToken;
      await _apiService.post(
        EndPoints.addToCart,
        data: {'productId': productId, 'quantity': quantity},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Failed to add to cart'));
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final token = CacheService.instance.accessToken;
      await _apiService.delete(
        EndPoints.productById(productId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Failed to delete product'));
    }
  }

  @override
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final token = CacheService.instance.accessToken;
      await _apiService.post(
        EndPoints.products,
        data: productData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Failed to create product'));
    }
  }

  @override
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      final token = CacheService.instance.accessToken;
      await _apiService.post(
        EndPoints.reviewsBase,
        data: {'productId': productId, 'rating': rating, 'comment': comment},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Failed to submit review'));
    }
  }
}
