// ... (imports and state classes remain the same) ...

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cart_model.dart';
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

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // Local cart for demo (in production, use API)
  final List<CartItemModel> _localItems = [];

  List<CartItemModel> get items => _localItems;
  double get subtotal => _localItems.fold(0, (sum, item) => sum + item.totalPrice);
  int get itemCount => _localItems.fold(0, (sum, item) => sum + item.quantity);

  /// 🔐 ADD THIS METHOD
  /// Emits the current state of the locally stored cart.
  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      // In a local-only setup, we just emit the current items.
      _emitCartLoaded();
    } catch (e) {
      emit(CartError("Failed to load cart data: ${e.toString()}"));
    }
  }

  /// Add item to cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
    required String productName, // Add these to create a more realistic item
    required double price,
    String? imageUrl,
  }) async {
    // No need for CartLoading() here, it feels snappier without it for local operations
    try {
      final existingIndex = _localItems.indexWhere((item) => item.productId == productId);

      if (existingIndex >= 0) {
        final existing = _localItems[existingIndex];
        _localItems[existingIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
        );
      } else {
        // Add new item with real data
        _localItems.add(
          CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: productId,
            productName: productName,
            productCoverUrl: imageUrl ?? '',
            productStock: 100, // Mocked stock
            quantity: quantity,
            basePricePerUnit: price,
            finalPricePerUnit: price, // Assuming no discounts for now
            totalPrice: price * quantity,
          ),
        );
      }

      emit(CartItemAdded()); // Notify that an item was added
      _emitCartLoaded(); // Then emit the new state of the entire cart
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ... (removeFromCart, updateQuantity, clearCart, _emitCartLoaded methods are correct and remain the same) ...

  /// Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      _localItems.removeWhere((item) => item.id == itemId);
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity <= 0) {
      await removeFromCart(itemId);
      return;
    }
    try {
      final index = _localItems.indexWhere((item) => item.id == itemId);
      if (index >= 0) {
        final item = _localItems[index];
        _localItems[index] = item.copyWith(
          quantity: newQuantity,
          totalPrice: newQuantity * item.finalPricePerUnit,
        );
      }
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    try {
      _localItems.clear();
      _emitCartLoaded();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _emitCartLoaded() {
    // Recalculate totals before emitting
    final currentSubtotal = _localItems.fold(0.0, (sum, item) => sum + (item.finalPricePerUnit * item.quantity));
    emit(
      CartLoaded(
        CartModel(
          id: 'local_cart',
          items: List.from(_localItems), // Use a copy to prevent mutation issues
          subtotal: currentSubtotal,
          finalTotal: currentSubtotal,
        ),
      ),
    );
  }
}
