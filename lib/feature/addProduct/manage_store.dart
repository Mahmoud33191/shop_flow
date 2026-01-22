import 'package:flutter/material.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/add_product_screen.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/product_card.dart';
import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/search_widget.dart';
import 'package:shop_flow/feature/home/data/dataSource/product_data_source.dart';
import 'package:shop_flow/feature/home/data/models/product_model.dart';
import 'package:shop_flow/l10n/app_localizations.dart';
// import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/taps_widget.dart';
// import 'package:shop_flow/feature/addProduct/peresntation/srcreens/widgets/bottum_navigate.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  late ProductDataSource _dataSource;
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dataSource = ProductDataSource(ApiService());
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final products = await _dataSource.fetchProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception:', '').trim();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteProduct(ProductModel product) async {
    try {
      await _dataSource.deleteProduct(product.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.productDeleted(product.name),
            ),
          ),
        );
        _loadProducts(); // Refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.failedDelete}: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteProduct),
        content: Text(
          AppLocalizations.of(context)!.deleteProductConfirmation(product.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.manageStore,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.allProducts, // Or add "My Products" to arb
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 196, 219, 238),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_products.length} Active',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 7, 125, 221),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SearchWidget(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.errorPrefix(_error!),
                      ),
                    )
                  : _products.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noProductsFound,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return ProductCard(
                          productName: product.name,
                          productSKU: product.id.substring(
                            0,
                            8,
                          ), // Display part of ID as SKU
                          productImage: product.pictureUrl.isNotEmpty
                              ? product.pictureUrl
                              : 'https://via.placeholder.com/150',
                          productPrice: product.price,
                          stockCount: product.stock,
                          onDelete: () => _confirmDelete(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
          if (result == true) {
            _loadProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
