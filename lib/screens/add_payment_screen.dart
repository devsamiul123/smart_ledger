import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/payment_api_service.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({Key? key}) : super(key: key);

  @override
  _AddPaymentScreenState createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _paymentAccountController = TextEditingController();
  final TextEditingController _paidDateController = TextEditingController();

  String _selectedPaymentType = 'cash';
  List<String> _paymentTypes = ['cash', 'check', 'bank transfer', 'credit card'];
  bool _isLoading = false;
  final PaymentApiService _apiService = PaymentApiService();

  @override
  void initState() {
    super.initState();
    _paidDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    _paidAmountController.dispose();
    _paymentAccountController.dispose();
    _paidDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _paidDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final payment = Payment(
          orderId: _orderIdController.text,
          paidAmount: double.parse(_paidAmountController.text),
          paymentType: _selectedPaymentType,
          paymentAccount: _paymentAccountController.text.isEmpty
              ? "no account number for $_selectedPaymentType"
              : _paymentAccountController.text,
          paidDate: _paidDateController.text,
        );

        await _apiService.addPayment(payment);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding payment: ${e.toString()}'),
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
        title: const Text('Add Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  controller: _orderIdController,
                  decoration: const InputDecoration(
                    labelText: 'Order ID',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an order ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _paidAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Paid Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the paid amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Payment Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPaymentType,
                  items: _paymentTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentType = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _paymentAccountController,
                  decoration: const InputDecoration(
                    labelText: 'Payment Account (if applicable)',
                    border: OutlineInputBorder(),
                    hintText: 'Account number, reference, etc.',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _paidDateController,
                  decoration: InputDecoration(
                    labelText: 'Payment Date',
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
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Payment'),
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