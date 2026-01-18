import 'package:flutter/material.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/product_card.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/search_widget.dart';

import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/taps_widget.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/bottum_navigate.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey, height: 1),
        ),
        leading: Icon(Icons.arrow_back, size: 30),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings, size: 30),
          ),
        ],
        centerTitle: true,
        title: const Text(
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          'Manage Store',
        ),
      ),
      body: ListView(
        children: [
          const TapsWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Products',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 196, 219, 238),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '12 Active',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 7, 125, 221),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SearchWidget(),
          // Product Cards
          ProductCard(
            productName: 'HandBag',
            productSKU: 'SKU:NK-2313.handBag',
            productImage:
                'https://plus.unsplash.com/premium_photo-1664392147011-2a720f214e01?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D',
            productPrice: 200,
            stockCount: 5,
          ),
          ProductCard(
            productName: 'Head Phone',
            productSKU: 'SKU:JY-5688.HeadPhone',
            productImage:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHx8MA%3D%3D',
            productPrice: 150,
            stockCount: 1,
          ),
          ProductCard(
            productName: 'Hoodie',
            productSKU: 'SKU:JY-5688.Hoodie',
            productImage:
                'https://static.vecteezy.com/system/resources/thumbnails/046/286/908/small/clean-background-black-hoodie-on-hanger-professional-shot-photo.jpeg',
            productPrice: 120,
            stockCount: 3,
          ),
        ],
      ),
      bottomNavigationBar: ButtomNavigate(), // BottoM ButtoN
    );
  }
}
