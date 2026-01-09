import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> allProducts = List.generate(
    12,
    (index) => {
      "name": "Product ${index + 1}",
      "price": 20 + index,
      "image": null,
    },
  );

  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
  }

  void searchProduct(String query) {
    final result = allProducts.where((product) {
      return product["name"].toString().toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();

    setState(() {
      filteredProducts = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchProduct,
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                          child: Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["name"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "\$${product["price"]}",
                              style: const TextStyle(
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
          ),
        ],
      ),
    );
  }
}
