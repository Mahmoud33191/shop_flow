import 'package:flutter/material.dart';

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
          backgroundColor: const Color.fromARGB(255, 7, 125, 221),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: const Text(
          'Save Changes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
