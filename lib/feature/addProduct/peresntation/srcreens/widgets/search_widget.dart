import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/app_colors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Search by name or SKU',
            prefixIcon: Icon(
              Icons.search,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 16,
            ),
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
