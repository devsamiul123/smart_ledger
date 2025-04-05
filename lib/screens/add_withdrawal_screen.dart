import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/withdrawal_api_service.dart';

class AddWithdrawalScreen extends StatefulWidget {
  const AddWithdrawalScreen({Key? key}) : super(key: key);

  @override
  _AddWithdrawalScreenState createState() => _AddWithdrawalScreenState();
}

class _AddWithdrawalScreenState extends State<AddWithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _withdrawAmountController = TextEditingController();
  final TextEditingController _withdrawDateController = TextEditingController();

  bool _isLoading = false;
  final WithdrawalApiService _apiService = WithdrawalApiService();

  @override
  void initState() {
    super.initState();
    _withdrawDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _withdrawAmountController.dispose();
    _withdrawDateController.dispose();
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
        _withdrawDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final withdrawal = Withdrawal(
          withdrawAmount: double.parse(_withdrawAmountController.text),
          withdrawDate: _withdrawDateController.text,
        );

        await _apiService.addWithdrawal(withdrawal);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Withdrawal added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding withdrawal: ${e.toString()}'),
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
        title: const Text('Add Withdrawal'),
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
                  controller: _withdrawAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Withdrawal Amount',
                    border: OutlineInputBorder(),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the withdrawal amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _withdrawDateController,
                  decoration: InputDecoration(
                    labelText: 'Withdrawal Date',
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
                      : const Text('Add Withdrawal'),
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