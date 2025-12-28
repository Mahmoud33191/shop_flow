import 'package:flutter/material.dart';

import '../helper/color_manager.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.validator,
    this.isPassword = false,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText, // Use hintText property, not hint widget for cleaner look
        suffixIcon: Icon(icon),
        hintStyle: TextStyle(color: ColorManager().greyTextColor),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
