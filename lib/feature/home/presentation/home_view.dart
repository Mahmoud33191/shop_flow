import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/cubit/app_cubit.dart';
import '../../../core/theme/app_colors.dart';

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

        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
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

      body: GridView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: context.watch<AppCubit>().state.themeMode == ThemeMode.dark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
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
                    child: Image.asset(
                      'images/images.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 18, bottom: 12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Product Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        "\$20",
                        style: TextStyle(
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
      ),
    );
  }
}
