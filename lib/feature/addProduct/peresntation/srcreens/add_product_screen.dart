import 'package:flutter/material.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';

import 'package:shop_flow/core/utils/custom_button.dart';
import 'package:shop_flow/core/utils/custom_text_field.dart';
import 'package:shop_flow/feature/home/data/dataSource/product_data_source.dart';
import 'package:shop_flow/feature/home/data/models/category_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();
  final _arabicNameController = TextEditingController();
  final _arabicDescController = TextEditingController();


  String? _selectedCategory;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  late final ProductDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ProductDataSource(ApiService());
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _dataSource.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          if (_categories.isNotEmpty) {
            // Depending on how category is stored (ID or name)
            // ProductModel uses List<String> categories.
            // We'll assume we send category names or IDs.
            // Let's use name for now as the API response showed categories: []
            // Wait, the CategoryModel has id and name.
          }
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null && _categories.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final productData = {
          'name': _nameController.text,
          'arabicName': _arabicNameController.text,

          'description': _descController.text,
          'arabicDescription': _arabicDescController.text,

          'price': double.tryParse(_priceController.text) ?? 0.0,
          'stock': int.tryParse(_stockController.text) ?? 0,
          'coverPictureUrl': _imageController.text,
          'categories': _selectedCategory != null ? [_selectedCategory!] : [],
          // Add other fields if necessary
        };

        await _dataSource.addProduct(productData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to refresh list
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to add product: ${e.toString().replaceAll("Exception: ", "")}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Product Name',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _arabicNameController,
                hintText: 'Arabic Name',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descController,
                hintText: 'Description',
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _arabicDescController,
                hintText: 'Arabic Description',
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter description' : null,
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      hintText: 'Price',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _stockController,
                      hintText: 'Stock',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageController,
                hintText: 'Image URL',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter image URL' : null,
              ),
              const SizedBox(height: 16),
              const Text('Select Category:'),
              const SizedBox(height: 8),
              // Dropdown for categories

              if (_categories.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Category'),
                      value: _selectedCategory,
                      items: _categories.map((c) {
                        return DropdownMenuItem(
                          value: c
                              .name, // Using name as ID might not be available or name is what's expected
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? 'Adding...' : 'Add Product',
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}