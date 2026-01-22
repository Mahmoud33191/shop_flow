import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop_flow/core/theme/app_colors.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';
import 'package:shop_flow/feature/home/data/models/offer_model.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';
import 'package:shop_flow/feature/home/presentation/cubit/home_cubit.dart';
import 'package:shop_flow/feature/home/presentation/cubit/home_states.dart';
import 'package:shop_flow/feature/home/presentation/screens/product_details_screen.dart';
import 'package:shop_flow/l10n/app_localizations.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Handle Loading State
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle Error State
        if (state is HomeError) {
          return _buildErrorWidget(context, state.message);
        }

        // Handle Legacy ProductsLoading state
        if (state is ProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle Legacy ProductsError state
        if (state is ProductsError) {
          return _buildErrorWidget(context, state.message);
        }

        // Handle Legacy ProductsLoaded state
        if (state is ProductsLoaded) {
          return _buildProductsGrid(context, state.products, []);
        }

        // Handle HomeLoaded State
        if (state is HomeLoaded) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: CustomScrollView(
                slivers: [
                  // Offers Section
                  if (state.filteredOffers.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildOffersSection(context, state.filteredOffers),
                    ),

                  // Categories Section
                  if (state.categories.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildCategoriesSection(
                        context,
                        state.categories,
                        state.selectedCategoryId,
                      ),
                    ),

                  // Products Section
                  if (state.isLoadingMore)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.filteredProducts.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noProductsFound,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (state.selectedCategoryId != null ||
                                state.searchQuery != null) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  context.read<HomeCubit>().filterByCategory(
                                    null,
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.showAllProducts,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Products Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.selectedCategoryId != null
                                  ? AppLocalizations.of(
                                      context,
                                    )!.filteredProducts
                                  : AppLocalizations.of(context)!.allProducts,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${state.filteredProducts.length} ${AppLocalizations.of(context)!.items}',
                              style: TextStyle(
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Products Grid
                    SliverPadding(
                      padding: const EdgeInsets.all(12),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = state.filteredProducts[index];
                          return _buildProductCard(context, product);
                        }, childCount: state.filteredProducts.length),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Build horizontal product sections for each category
  List<Widget> _buildCategorySections(BuildContext context, HomeLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> sections = [];

    // If no categories or products, show nothing
    if (state.categories.isEmpty || state.products.isEmpty) {
      return sections;
    }

    // Create a map of category name to products
    final Map<String, List<ProductModel>> categoryProductsMap = {};

    for (final product in state.products) {
      for (final categoryName in product.categories) {
        categoryProductsMap.putIfAbsent(categoryName, () => []);
        categoryProductsMap[categoryName]!.add(product);
      }
    }

    // Build sections for each category that has products
    for (final category in state.categories) {
      final categoryProducts = categoryProductsMap[category.name] ?? [];

      if (categoryProducts.isEmpty) continue;

      sections.add(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.category_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<HomeCubit>().filterByCategory(category.id);
                      },
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.viewAll,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Horizontal Product List
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categoryProducts.length > 10
                      ? 10
                      : categoryProducts.length,
                  itemBuilder: (context, index) {
                    final product = categoryProducts[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildProductCard(context, product),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If no sections were created (products have no categories), show all products in one section
    if (sections.isEmpty && state.products.isNotEmpty) {
      sections.add(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Text(
                  AppLocalizations.of(context)!.allProducts,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.products.length > 10
                      ? 10
                      : state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildProductCard(context, product),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeCubit>().fetchHomeData(),
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersSection(BuildContext context, List<OfferModel> offers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Icon(Icons.local_offer, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.specialOffers,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return _buildOfferCard(context, offer);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferModel offer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          if (offer.imageUrl != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: offer.imageUrl!,
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black.withValues(alpha: 0.3),
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${offer.discountPercentage.toInt()}% OFF',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  offer.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (offer.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    offer.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    List<CategoryModel> categories,
    int? selectedCategoryId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            AppLocalizations.of(context)!.categories,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length + 1, // +1 for "All" option
            itemBuilder: (context, index) {
              if (index == 0) {
                // "All" category
                final isSelected = selectedCategoryId == null;
                return _buildCategoryChip(
                  context,
                  AppLocalizations.of(context)!.all,
                  isSelected,
                  () => context.read<HomeCubit>().filterByCategory(null),
                );
              }
              final category = categories[index - 1];
              final isSelected = selectedCategoryId == category.id;
              return _buildCategoryChip(
                context,
                category.name,
                isSelected,
                () => context.read<HomeCubit>().filterByCategory(category.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String name,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : Colors.grey[100]),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.white10 : Colors.grey[300]!,
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid(
    BuildContext context,
    List<ProductModel> products,
    List<CategoryModel> categories,
  ) {
    if (products.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noProductsFound));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(context, product);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.pictureUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  // Add to cart quick button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
