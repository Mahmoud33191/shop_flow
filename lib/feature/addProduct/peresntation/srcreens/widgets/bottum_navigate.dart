import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/app_colors.dart';
import 'package:shop_flow/l10n/app_localizations.dart';

class ButtomNavigate extends StatelessWidget {
  const ButtomNavigate({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.save, color: Colors.white, size: 24),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        label: Text(
          AppLocalizations.of(context)!.saveChanges,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
