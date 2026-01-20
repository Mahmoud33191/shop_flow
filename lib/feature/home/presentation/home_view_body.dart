import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/core/cubit/app_cubit.dart';
import 'package:shop_flow/core/theme/app_colors.dart';
import 'package:shop_flow/feature/home/presentation/cubit/home_cubit.dart';

import 'cubit/home_states.dart';

// 1. Create a new StatelessWidget for the body
class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Get the current state from the HomeCubit
    final state = context.watch<HomeCubit>().state;

    // 3. Handle Loading State
    if (state is ProductsLoading || state is ProductsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    // 4. Handle Error State
    if (state is ProductsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Allow the user to retry fetching the data
                context.read<HomeCubit>().fetchProducts();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // 5. Handle Success State
    if (state is ProductsLoaded) {
      final products = state.products;

      if (products.isEmpty) {
        return const Center(child: Text("No products found."));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            decoration: BoxDecoration(
              color: context.watch<AppCubit>().state.themeMode == ThemeMode.dark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      product.pictureUrl, // <-- Use real data
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                    bottom: 12,
                    right: 8,
                    top: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name, // <-- Use real data
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "\$${product.price}", // <-- Use real data
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // Default fallback (should not be reached if states are handled correctly)
    return const SizedBox.shrink();
  }
}
