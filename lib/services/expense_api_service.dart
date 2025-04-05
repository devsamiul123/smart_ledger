// services/expense_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Expense {
  final int? id;
  final String description;
  final double paidAmount;
  final String expenseDate;
  final String? createdAt;
  final String? updatedAt;

  Expense({
    this.id,
    required this.description,
    required this.paidAmount,
    required this.expenseDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      paidAmount: json['paid_amount'].toDouble(),
      expenseDate: json['expense_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'paid_amount': paidAmount,
      'expense_date': expenseDate,
    };
  }
}

class ExpenseApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Expense>> getExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl/expense'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Expense.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load expenses. Status code: ${response.statusCode}');
    }
  }

  Future<bool> addExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl/expense'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add expense. Status code: ${response.statusCode}');
    }
  }

  // create a delete request
  Future<bool> deleteExpense(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/expense/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete expense. Status code: ${response.statusCode}');
    }
  }

  // create a update request
  Future<bool> updateExpense(Expense expense) async {
    final response = await http.put(
      Uri.parse('$baseUrl/expense/${expense.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to update expense. Status code: ${response.statusCode}');
    }
  }
}