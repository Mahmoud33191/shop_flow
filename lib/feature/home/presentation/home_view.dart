import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/cubit/app_cubit.dart';
import 'cubit/home_cubit.dart';
import 'home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => HomeCubit()..fetchHomeData(),
      child: Scaffold(
        appBar: AppBar(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: SvgPicture.asset(
            isDark
                ? 'assets/img/online_shop_logo_dark.svg'
                : 'assets/img/online_shop_logo.svg',
            height: 100,
            width: 100,
          ),
          actions: [
            // Search button
            IconButton(
              onPressed: () {
                // Navigate to search
              },
              icon: const Icon(Icons.search),
            ),
            // Theme toggle
            IconButton(
              onPressed: () {
                context.read<AppCubit>().toggleTheme();
              },
              icon: Icon(
                context.watch<AppCubit>().state.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            // Notifications
            IconButton(
              onPressed: () {
                // Navigate to notifications
              },
              icon: Badge(
                isLabelVisible: false,
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
          ],
        ),
        body: const HomeViewBody(),
      ),
    );
  }
}
