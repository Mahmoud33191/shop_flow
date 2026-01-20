import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/cubit/app_cubit.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_states.dart';
import 'home_view_body.dart'; // Import the states

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 1. Create the cubit instance and immediately call the method to fetch data.
      create: (context) => HomeCubit()..fetchProducts(),
      // 2. Use BlocBuilder to listen to state changes from HomeCubit and rebuild the UI.
      child: BlocBuilder<HomeCubit, ProductsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: SvgPicture.asset(
                'assets/img/online_shop_logo.svg',
                height: 100,
                width: 100,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart),
                ),
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
              ],
            ),

            // 3. Conditionally render the body based on the current state.
            body: const HomeViewBody(),
          );
        },
      ),
    );
  }


}
