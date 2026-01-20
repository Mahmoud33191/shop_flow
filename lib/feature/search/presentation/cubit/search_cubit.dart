// The 'part of' directive links this file to the cubit file.

// The base abstract class no longer needs to extend Equatable.
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/data/dataSource/product_data_source.dart';
import '../../../home/data/models/product_model.dart';

abstract class SearchState {
  const SearchState();
}

// Initial state when the screen is first opened.
class SearchInitial extends SearchState {}

// State when a search is in progress.
class SearchLoading extends SearchState {}

// State when products have been successfully found.
class SearchLoaded extends SearchState {
  final List<ProductModel> products;
  const SearchLoaded(this.products);
}

// State when the search completes but finds no results.
class SearchEmpty extends SearchState {
  final String message;
  const SearchEmpty(this.message);
}

// State when an error occurs during the search.
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}

// The 'part' directive links the state definitions from the other file.




class SearchCubit extends Cubit<SearchState> {
  final IProductDataSource _productDataSource;

  SearchCubit(this._productDataSource) : super(SearchInitial());

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      // Directly call the data source method
      final products = await _productDataSource.fetchProducts(searchQuery: query);

      if (products.isEmpty) {
        emit(const SearchEmpty("No products found matching your search."));
      } else {
        emit(SearchLoaded(products));
      }
    } catch (e) {
      emit(SearchError("Failed to fetch search results: ${e.toString()}"));
    }
  }
}
