import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/app_colors.dart';

class TapsWidget extends StatefulWidget {
  const TapsWidget({super.key});

  @override
  State<TapsWidget> createState() => _TapsWidgetState();
}

class _TapsWidgetState extends State<TapsWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2, // Two tabs: Inventory and Add New
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: MediaQuery.of(context).size.width * 0.42,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selectedIndex == index
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  index == 0 ? 'Inventory' : 'Add New',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selectedIndex == index
                        ? Colors.white
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
