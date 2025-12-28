import 'package:flutter/material.dart';
import 'package:shop_flow/core/helper/color_manager.dart';

class CustomButton extends StatelessWidget {

   const CustomButton({super.key, required this.text, required this.onPressed, this.icon});
final void Function()? onPressed;
 final  String text;
final IconData? icon;


  @override
  Widget build(BuildContext context) {


    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager().primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      onPressed: () {
        // Handle button press
        onPressed;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Icon(icon)
        ],
      ),
    );
  }
}
