class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String productCoverUrl;
  final int productStock;
  final int quantity;
  final double basePricePerUnit;
  final double finalPricePerUnit;
  final double totalPrice;
  final double discountPercentage;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productCoverUrl,
    required this.productStock,
    required this.quantity,
    required this.basePricePerUnit,
    required this.finalPricePerUnit,
    required this.totalPrice,
    this.discountPercentage = 0,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['itemId']?.toString() ?? json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName'] ?? '',
      productCoverUrl: json['productCoverUrl'] ?? '',
      productStock: json['productStock'] ?? 0,
      quantity: json['quantity'] ?? 1,
      basePricePerUnit: (json['basePricePerUnit'] ?? 0).toDouble(),
      finalPricePerUnit:
          (json['finalPricePerUnit'] ?? json['basePricePerUnit'] ?? 0)
              .toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
    );
  }

  CartItemModel copyWith({int? quantity, double? totalPrice}) {
    return CartItemModel(
      id: id,
      productId: productId,
      productName: productName,
      productCoverUrl: productCoverUrl,
      productStock: productStock,
      quantity: quantity ?? this.quantity,
      basePricePerUnit: basePricePerUnit,
      finalPricePerUnit: finalPricePerUnit,
      totalPrice: totalPrice ?? this.totalPrice,
      discountPercentage: discountPercentage,
    );
  }
}

class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double subtotal;
  final double discountAmount;
  final double finalTotal;

  CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0,
    required this.finalTotal,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] ?? [];
    return CartModel(
      id: json['id']?.toString() ?? json['cartId']?.toString() ?? '',
      items: (itemsList as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: (json['subtotal'] ?? json['originalTotal'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      finalTotal: (json['finalTotal'] ?? json['subtotal'] ?? 0).toDouble(),
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
