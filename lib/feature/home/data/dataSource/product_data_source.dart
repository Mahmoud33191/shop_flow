import 'package:dio/dio.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';
import 'package:shop_flow/core/network/api/end_points.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';

/// Abstract class defining the contract for product and category data operations.
/// This makes the data source easily mockable for testing.
abstract class IProductDataSource {
  /// Fetches a list of all product categories from the API.
  Future<List<CategoryModel>> fetchCategories();

  /// Fetches a list of products.
  /// Can be filtered by [categoryId]. If [categoryId] is null, it fetches all products.
  Future<List<ProductModel>> fetchProducts({int? categoryId});
}

/// Concrete implementation of the IProductDataSource using Dio.
class ProductDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductDataSource(this._apiService);

  @override
  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final Response response = await _apiService.get(EndPoints.categories);

      // Assuming the API returns a list of JSON objects
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        // Convert the list of JSON objects to a list of CategoryModel objects
        return data.map((categoryJson) => CategoryModel.fromJson(categoryJson)).toList();
      } else {
        // Handle cases where the response is not as expected
        throw Exception('Failed to load categories: Invalid response format');
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors (network issues, timeouts, etc.)
      // You can log the error or re-throw a more user-friendly exception
      throw Exception('Failed to load categories: ${dioError.message}');
    } catch (e) {
      // Handle other potential errors
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ProductModel>> fetchProducts({int? categoryId}) async {
    try {
      // Prepare query parameters if a categoryId is provided
      final Map<String, dynamic>? queryParameters =
      categoryId != null ? {'categoryId': categoryId} : null;

      final Response response = await _apiService.get(
        EndPoints.products,
        queryParameters: queryParameters,
      );

      // Assuming the API returns a list of JSON objects
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        // Convert the list of JSON objects to a list of ProductModel objects
        return data.map((productJson) => ProductModel.fromJson(productJson)).toList();
      } else {
        throw Exception('Failed to load products: Invalid response format');
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors
      throw Exception('Failed to load products: ${dioError.message}');
    } catch (e) {
      // Handle other potential errors
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
