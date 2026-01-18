import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/feature/addProduct/manage_store.dart';
import 'package:shop_flow/feature/home/presentation/home_view.dart';

import '../../feature/profile/profile_screen.dart';
import '../theme/app_colors.dart';
import 'nav_bar_cubit.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final List<Widget> pages = [
    HomeView(),
    Center(child: Text('Search Page')),
    Center(child: Text('Cart Page')),

    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            // 1. Use the actual FloatingActionButton widget for the circular shape
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageStore()));
                // Add your action here
              },
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(), // Ensures it is perfectly round
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            body: IndexedStack(index: currentIndex, children: pages),

            // 2. Use BottomAppBar to enable the notch effect
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              // Creates the notch
              notchMargin: 8.0,
              // Space between FAB and the bar
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.zero,
              height: 70,
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                // Make transparent to show BottomAppBar
                elevation: 0,
                // Remove shadow so it blends in
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<NavigationCubit>().updateIndex(index);
                },
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
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
