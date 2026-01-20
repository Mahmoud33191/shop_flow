import 'package:shop_flow/feature/home/data/models/category_model.dart';
import 'package:shop_flow/feature/home/data/models/offer_model.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';

/// Base state for Home screen
abstract class HomeState {}

/// Initial state
class HomeInitial extends HomeState {}

/// Loading state
class HomeLoading extends HomeState {}

/// Loaded state with all data
class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final int? selectedCategoryId;
  final bool isLoadingMore;

  HomeLoaded({
    required this.products,
    required this.filteredProducts,
    required this.categories,
    required this.offers,
    this.selectedCategoryId,
    this.isLoadingMore = false,
  });

  HomeLoaded copyWith({
    List<ProductModel>? products,
    List<ProductModel>? filteredProducts,
    List<CategoryModel>? categories,
    List<OfferModel>? offers,
    int? selectedCategoryId,
    bool? isLoadingMore,
    bool clearCategoryFilter = false,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      offers: offers ?? this.offers,
      selectedCategoryId: clearCategoryFilter
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// Legacy states for backward compatibility
class ProductsState extends HomeState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  ProductsLoaded(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
