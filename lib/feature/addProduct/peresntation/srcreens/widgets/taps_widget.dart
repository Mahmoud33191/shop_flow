import 'package:flutter/material.dart';

class TapsWidget extends StatefulWidget {
  const TapsWidget({super.key});

  @override
  State<TapsWidget> createState() => _TapsWidgetState();
}

class _TapsWidgetState extends State<TapsWidget> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2, // Two tabs: Inventory and Add New
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 45,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Colors
                            .white // Selected tab color
                      : Colors
                            .grey
                            .shade300, // Unselected tab color => normal color of the container
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  index == 0 ? 'Inventory' : 'Add New',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selectedIndex == index ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
