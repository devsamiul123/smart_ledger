import 'package:flutter/material.dart';
import '../services/product_api_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _unitPriceController;
  late TextEditingController _unitTypeController;

  final ProductApiService _apiService = ProductApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.product.productName);
    _unitPriceController = TextEditingController(text: widget.product.unitPrice.toString());
    _unitTypeController = TextEditingController(text: widget.product.unitType);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _unitPriceController.dispose();
    _unitTypeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final productData = {
          "product_name": _productNameController.text,
          "unit_price": double.parse(_unitPriceController.text),
          "unit_type": _unitTypeController.text,
        };

        await _apiService.updateProduct(widget.product.id, productData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); // Pass result back to indicate success
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating product: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
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
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Unit Type (e.g., sft, kg)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a unit type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update Product'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}