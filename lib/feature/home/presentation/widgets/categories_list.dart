import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/app_colors.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';

class CategoriesList extends StatelessWidget {
  final List<CategoryModel> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;

  const CategoriesList({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Categories',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length + 1, // +1 for "All" category
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryChip(
                  context,
                  name: 'All',
                  isSelected: selectedCategoryId == null,
                  onTap: () => onCategorySelected(null),
                  isDark: isDark,
                );
              }
              final category = categories[index - 1];
              return _buildCategoryChip(
                context,
                name: category.name,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
