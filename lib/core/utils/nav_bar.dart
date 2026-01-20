import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/feature/addProduct/manage_store.dart';
import 'package:shop_flow/feature/home/presentation/home_view.dart';
import 'package:shop_flow/feature/cart/presentation/screens/cart_screen.dart';
import 'package:shop_flow/feature/cart/presentation/cubit/cart_cubit.dart';

import '../../feature/profile/profile_screen.dart';
import '../theme/app_colors.dart';
import 'nav_bar_cubit.dart';
import 'package:shop_flow/l10n/app_localizations.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<Widget> pages = [
    const HomeView(),
    const Center(child: Text('Search Page')),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            // 1. Use the actual FloatingActionButton widget for the circular shape
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageStore()),
                );
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            body: IndexedStack(index: currentIndex, children: pages),

            // 2. Use BottomAppBar to enable the notch effect
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.zero,
              height: 70,
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavigationCubit>().updateIndex(index);
                },
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: AppLocalizations.of(context)!.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: AppLocalizations.of(context)!.search,
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        final count = context.read<CartCubit>().itemCount;
                        return Badge(
                          isLabelVisible: count > 0,
                          label: Text('$count'),
                          child: const Icon(Icons.shopping_cart),
                        );
                      },
                    ),
                    label: AppLocalizations.of(context)!.cart,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: AppLocalizations.of(context)!.profile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
