import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';
import 'package:shop_flow/feature/home/data/dataSource/product_data_source.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';
import 'package:shop_flow/feature/home/data/models/offer_model.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';
import 'package:shop_flow/feature/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductDataSource _productDataSource;

  HomeCubit({ProductDataSource? productDataSource})
    : _productDataSource = productDataSource ?? ProductDataSource(ApiService()),
      super(HomeInitial());

  List<ProductModel> _allProducts = [];
  List<CategoryModel> _categories = [];
  List<OfferModel> _offers = [];

  /// Fetch all home data (products, categories, offers)
  /// Uses graceful degradation - continues even if some APIs fail
  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    String? lastError;

    // Fetch products first (required)
    try {
      _allProducts = await _productDataSource.fetchProducts();
    } catch (e) {
      lastError = e.toString().replaceAll('Exception:', '').trim();
      debugPrint('Products fetch error: $e');
      _allProducts = [];
    }

    // Fetch categories (optional - continue even if fails)
    try {
      _categories = await _productDataSource.fetchCategories();
    } catch (e) {
      debugPrint('Categories fetch error: $e');
      _categories = [];
    }

    // Fetch offers (optional - continue even if fails)
    try {
      _offers = await _productDataSource.fetchOffers();
    } catch (e) {
      debugPrint('Offers fetch error: $e');
      _offers = [];
    }

    // If we have products, show them even if other data failed
    if (_allProducts.isNotEmpty) {
      emit(
        HomeLoaded(
          products: _allProducts,
          filteredProducts: _allProducts,
          categories: _categories,
          offers: _offers,
          filteredOffers: _offers,
          selectedCategoryId: null,
        ),
      );
    } else if (lastError != null) {
      // Only show error if products also failed
      emit(HomeError(lastError));
    } else {
      // No products and no error = empty state
      emit(
        HomeLoaded(
          products: [],
          filteredProducts: [],
          categories: _categories,
          offers: _offers,
          filteredOffers: _offers,
          selectedCategoryId: null,
        ),
      );
    }
  }

  /// Legacy method for backward compatibility
  Future<void> fetchProducts({int? categoryId}) async {
    if (state is HomeInitial) {
      await fetchHomeData();
    } else if (categoryId != null) {
      filterByCategory(categoryId);
    }
  }

  /// Filter products by category
  Future<void> filterByCategory(int? categoryId) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    // If already selected, do nothing
    if (currentState.selectedCategoryId == categoryId &&
        currentState.searchQuery == null)
      return;

    emit(
      currentState.copyWith(
        isLoadingMore: true,
        selectedCategoryId: categoryId,
        clearSearchQuery: true,
      ),
    );

    try {
      final products = await _productDataSource.fetchProducts(
        categoryId: categoryId,
      );

      // Filter offers based on category
      // For now, show all offers regardless of category since API doesn't support category-based offers
      // In future, this can be updated when API provides categoryId with offers
      final filteredOffers = _offers;

      emit(
        currentState.copyWith(
          filteredProducts: products,
          filteredOffers: filteredOffers,
          selectedCategoryId: categoryId,
          isLoadingMore: false,
          clearSearchQuery: true,
          clearCategoryFilter: categoryId == null,
        ),
      );
    } catch (e) {
      debugPrint('Filter by category failed: $e');
      emit(currentState.copyWith(isLoadingMore: false));
      // Optionally emit error or keep old state
    }
  }

  /// Search products by query
  Future<void> searchProducts(String query) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;

    if (query.isEmpty) {
      // If query is cleared, reset to current category or all products
      await filterByCategory(currentState.selectedCategoryId);
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, searchQuery: query));

    try {
      final products = await _productDataSource.fetchProducts(
        categoryId: currentState.selectedCategoryId,
        searchQuery: query,
      );

      emit(
        currentState.copyWith(
          filteredProducts: products,
          searchQuery: query,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      debugPrint('Search products failed: $e');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Clear search and filters
  Future<void> clearFilters() async {
    await fetchHomeData();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await fetchHomeData();
  }

  /// Get current products (for backward compatibility)
  List<ProductModel> get products {
    if (state is HomeLoaded) {
      return (state as HomeLoaded).filteredProducts;
    }
    return [];
  }

  /// Get current categories
  List<CategoryModel> get categories => _categories;

  /// Get current offers
  List<OfferModel> get offers => _offers;
}
