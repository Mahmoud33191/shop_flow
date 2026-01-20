import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final int stockCount;

  const StockBadge({super.key, required this.stockCount});

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = stockCount == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: outOfStock
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // مهم جدًا
        children: [
          /// النقطة اللي قبل النص
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: outOfStock ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(1),
            ),
          ),

          const SizedBox(width: 6),

          /// النص
          Text(
            outOfStock ? 'Out of stock' : '$stockCount in stock',
            style: TextStyle(
              color: outOfStock ? Colors.red : Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
