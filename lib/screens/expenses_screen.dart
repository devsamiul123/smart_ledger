// screens/expenses_screen.dart
import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'add_payment_screen.dart';
import 'add_withdrawal_screen.dart';
import '../services/expense_api_service.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseApiService _apiService = ExpenseApiService();
  List<Expense> expenses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final fetchedExpenses = await _apiService.getExpenses();
      setState(() {
        expenses = fetchedExpenses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching expenses: $e';
        isLoading = false;
      });
    }
  }

  void _navigateToAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    );
    if (result == true) {
      fetchExpenses();
    }
  }

  void _navigateToAddPayment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPaymentScreen()),
    );
    if (result == true) {
      fetchExpenses();
    }
  }

  void _navigateToAddWithdrawal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWithdrawalScreen()),
    );
    if (result == true) {
      fetchExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _navigateToAddPayment,
                  icon: const Icon(Icons.payment),
                  label: const Text('Add Payment'),
                ),
                ElevatedButton.icon(
                  onPressed: _navigateToAddWithdrawal,
                  icon: const Icon(Icons.money_off),
                  label: const Text('Withdrawings'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchExpenses,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
                  : expenses.isEmpty
                  ? const Center(child: Text('No expenses found'))
                  : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount: \$${expense.paidAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date: ${expense.expenseDate}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            expense.description,
                            style: const TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // call the delete method from services/expense_api_service.dart
                                  _apiService.deleteExpense(expense.id!).then((success) {
                                    if (success) {
                                      setState(() {
                                        expenses.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Expense deleted successfully')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to delete expense')),
                                      );
                                    }
                                  });
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}