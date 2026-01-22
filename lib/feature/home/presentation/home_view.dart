import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop_flow/core/theme/app_colors.dart';
import 'package:shop_flow/l10n/app_localizations.dart';
import '../../../core/cubit/app_cubit.dart';
import 'cubit/home_cubit.dart';
import 'home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => HomeCubit()..fetchHomeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
              surfaceTintColor: Colors.transparent,
              title: _isSearching
                  ? Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.searchProducts,
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
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
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              context.read<HomeCubit>().searchProducts(value);
                            },
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        isDark
                            ? 'assets/img/online_shop_logo_dark.svg'
                            : 'assets/img/online_shop_logo.svg',
                        height: 32,
                      ),
                    ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _isSearching
                        ? (isDark
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1))
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                          context.read<HomeCubit>().searchProducts('');
                        }
                      });
                    },
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search_rounded,
                      color: _isSearching
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ),
                if (!_isSearching) ...[
                  IconButton(
                    onPressed: () {
                      context.read<AppCubit>().toggleTheme();
                    },
                    icon: Icon(
                      context.watch<AppCubit>().state.themeMode ==
                              ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Navigate to notifications
                    },
                    icon: Badge(
                      backgroundColor: AppColors.primary,
                      isLabelVisible: true,
                      label: const Text(
                        '2',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            body: const HomeViewBody(),
          );
        },
      ),
    );
  }
}
