import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/app_colors.dart';

class StockBadge extends StatelessWidget {
  final int stockCount;

  const StockBadge({super.key, required this.stockCount});

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = stockCount == 0;
    final Color color = outOfStock ? AppColors.error : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            outOfStock ? 'Out of stock' : '$stockCount in stock',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
