import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/feature/cart/data/models/cart_model.dart';

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}

class CartItemAdded extends CartState {
  final String message;
  CartItemAdded([this.message = 'Added to cart']);
}

// Cubit
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // Local cart for demo (in production, use API)
  final List<CartItemModel> _localItems = [];

  List<CartItemModel> get items => _localItems;

  double get subtotal =>
      _localItems.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount => _localItems.fold(0, (sum, item) => sum + item.quantity);

  /// Add item to cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
  }) async {
    emit(CartLoading());
    try {
      // Check if item already exists
      final existingIndex = _localItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (existingIndex >= 0) {
        // Update quantity
        final existing = _localItems[existingIndex];
        _localItems[existingIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
          totalPrice:
              (existing.quantity + quantity) * existing.finalPricePerUnit,
        );
      } else {
        // Add new item (mock data)
        _localItems.add(
          CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            productName: 'Product $productId',
            productCoverUrl: '',
            productStock: 100,
            quantity: quantity,
            basePricePerUnit: 0,
            finalPricePerUnit: 0,
            totalPrice: 0,
          ),
        );
      }

      emit(CartItemAdded());
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    emit(CartLoading());
    try {
      _localItems.removeWhere((item) => item.id == itemId);
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    emit(CartLoading());
    try {
      final index = _localItems.indexWhere((item) => item.id == itemId);
      if (index >= 0) {
        final item = _localItems[index];
        _localItems[index] = item.copyWith(
          quantity: quantity,
          totalPrice: quantity * item.finalPricePerUnit,
        );
      }
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    emit(CartLoading());
    try {
      _localItems.clear();
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _emitCartLoaded() {
    emit(
      CartLoaded(
        CartModel(
          id: 'local_cart',
          items: _localItems,
          subtotal: subtotal,
          finalTotal: subtotal,
        ),
      ),
    );
  }
}
