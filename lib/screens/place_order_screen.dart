import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/dashboard_api_service.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final DashboardApiService _apiService = DashboardApiService();

  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<OrderItem> _orderItems = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current date
    _dateController.text = DateFormat('d-MM-yyyy').format(DateTime.now());

    // Add one empty order item by default
    _addNewOrderItem();
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _addNewOrderItem() {
    setState(() {
      _orderItems.add(OrderItem(
        productId: 1,
        qty: 1,
        unitInNumber: 1,
        unitInString: "1x1",
      ));
    });
  }

  void _removeOrderItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('d-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      if (_orderItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one order item')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final order = Order(
          customerId: int.parse(_customerIdController.text),
          orderPlacingDate: _dateController.text,
          items: _orderItems,
        );

        final success = await _apiService.placeOrder(order);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed successfully!')),
          );
          Navigator.pop(context); // Return to dashboard
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place New Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer ID Field
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(
                  labelText: 'Customer ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker Field
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Order Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Order Items List
              ..._buildOrderItemsList(),

              const SizedBox(height: 16),

              // Add New Item Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addNewOrderItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Another Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrderItemsList() {
    return List.generate(_orderItems.length, (index) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Item ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _orderItems.length > 1 ? () => _removeOrderItem(index) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Product ID
              TextFormField(
                initialValue: _orderItems[index].productId.toString(),
                decoration: const InputDecoration(
                  labelText: 'Product ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _orderItems[index] = OrderItem(
                      productId: int.tryParse(value) ?? 1,
                      qty: _orderItems[index].qty,
                      unitInNumber: _orderItems[index].unitInNumber,
                      unitInString: _orderItems[index].unitInString,
                    );
                  });
                },
              ),
              const SizedBox(height: 12),

              // Quantity
              TextFormField(
                initialValue: _orderItems[index].qty.toString(),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _orderItems[index] = OrderItem(
                      productId: _orderItems[index].productId,
                      qty: int.tryParse(value) ?? 1,
                      unitInNumber: _orderItems[index].unitInNumber,
                      unitInString: _orderItems[index].unitInString,
                    );
                  });
                },
              ),
              const SizedBox(height: 12),

              // Unit in Number
              TextFormField(
                initialValue: _orderItems[index].unitInNumber.toString(),
                decoration: const InputDecoration(
                  labelText: 'Unit in Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _orderItems[index] = OrderItem(
                      productId: _orderItems[index].productId,
                      qty: _orderItems[index].qty,
                      unitInNumber: int.tryParse(value) ?? 1,
                      unitInString: _orderItems[index].unitInString,
                    );
                  });
                },
              ),
              const SizedBox(height: 12),

              // Unit in String
              TextFormField(
                initialValue: _orderItems[index].unitInString,
                decoration: const InputDecoration(
                  labelText: 'Unit in String (e.g. 2x30)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _orderItems[index] = OrderItem(
                      productId: _orderItems[index].productId,
                      qty: _orderItems[index].qty,
                      unitInNumber: _orderItems[index].unitInNumber,
                      unitInString: value,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}