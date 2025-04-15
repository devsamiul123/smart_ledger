import 'package:flutter/material.dart';
import '../services/customer_api_service.dart';
// import 'edit_customer_screen.dart';

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  _AllCustomersScreenState createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  final CustomerApiService _apiService = CustomerApiService();
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _refreshcustomers();
  }

  void _refreshcustomers() {
    setState(() {
      _customersFuture = _apiService.getAllCustomers();
    });
  }

  Future<void> _deleteCustomer(Customer customer) async {
    try {
      await _apiService.deleteCustomer(customer.id);
      // Refresh customers list after successful deletion
      _refreshcustomers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('customer deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting customer: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshcustomers,
          ),
        ],
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No customers available'),
            );
          } else {
            final customers = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Customer ID: ${customer.id}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCustomer(customer),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          customer.customer_name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mobile No: ${customer.mobile_no}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}