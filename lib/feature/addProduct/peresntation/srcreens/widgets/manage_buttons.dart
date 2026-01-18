import 'package:flutter/material.dart';

class ManageButtons extends StatelessWidget {
  const ManageButtons({
    super.key,
    required this.editbutton,
    required this.stockButton,
  });

  final String editbutton;
  final String stockButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 196, 219, 238),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: Text(
              style: TextStyle(
                color: const Color.fromARGB(255, 7, 125, 221),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              editbutton,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Color.fromARGB(255, 196, 219, 238),
            ),
            onPressed: () {},
            child: Text(
              style: TextStyle(
                color: const Color.fromARGB(255, 7, 125, 221),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              stockButton,
            ),
          ),
        ),
      ],
    );
  }
}
