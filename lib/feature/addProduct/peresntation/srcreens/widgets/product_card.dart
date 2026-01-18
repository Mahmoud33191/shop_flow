import 'package:flutter/material.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/manage_buttons.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/stocks_widget.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.productName,
    required this.productSKU,
    required this.productImage,
    required this.productPrice,
    required this.stockCount,
  });

  final String productName, productSKU, productImage;

  final double productPrice;

  final int stockCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 248, 248),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productImage,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            productName,
                          ),
                          SizedBox(height: 8),
                          Text(
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 141, 141, 141),
                            ),
                            productSKU,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                '$productPrice',
                              ),
                              StockBadge(stockCount: stockCount),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ManageButtons(
                  editbutton: 'Edit Detalis',
                  stockButton: 'Manage Stock',
                ),
              ],
            ),
          ),
          Positioned(right: 9, top: 9, child: Icon(Icons.delete)),
        ],
      ),
    );
  }
}
