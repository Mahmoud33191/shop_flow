import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/cubit/app_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: SvgPicture.asset(
          'assets/img/online_shop_logo.svg',
          height: 100,
          width: 100,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: IconButton(
            onPressed: () {
              context.read<AppCubit>().toggleTheme();
            },
            icon: Icon(
              context.watch<AppCubit>().state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ),

        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Text(
      //         'Welcome to MarketFlow',
      //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           context.read<AppCubit>().toggleTheme();
      //         },
      //         child: const Text('Change Theme'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
