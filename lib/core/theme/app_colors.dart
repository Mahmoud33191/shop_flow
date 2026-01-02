import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF4CA1FE); // Vibrant Blue from design

  // Backgrounds
  static const Color darkBackground = Color(
    0xFF0D1326,
  ); // Deep Navy from design
  static const Color lightBackground = Color(0xFFFFFFFF);

  // Surface / Cards / Inputs
  static const Color darkSurface = Color(
    0xFF1C233A,
  ); // Slightly lighter navy for inputs/cards
  static const Color lightSurface = Color(
    0xFFF5F5F5,
  ); // Light grey for inputs in light mode

  // Text
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFA0A4AB); // Greyish text

  static const Color textPrimaryLight = Color(0xFF111625);
  static const Color textSecondaryLight = Color(0xFF7D838B);

  // Error & Success
  static const Color error = Color(0xFFFF4C4C);
  static const Color success = Color(0xFF4CAF50);

  // Specific UI Elements
  static const Color darkInputFill = Color(0xFF1C233A);
  static const Color lightInputFill = Color(0xFFF5F5F5);
}
