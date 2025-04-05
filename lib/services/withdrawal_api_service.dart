import 'dart:convert';
import 'package:http/http.dart' as http;

class Withdrawal {
  final int? id;
  final double withdrawAmount;
  final String withdrawDate;

  Withdrawal({
    this.id,
    required this.withdrawAmount,
    required this.withdrawDate,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'],
      withdrawAmount: double.parse(json['withdraw_amount'].toString()),
      withdrawDate: json['withdraw_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'withdraw_amount': withdrawAmount,
      'withdraw_date': withdrawDate,
    };
  }
}

class WithdrawalApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client = http.Client();

  // Add a new withdrawal
  Future<Map<String, dynamic>> addWithdrawal(Withdrawal withdrawal) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(withdrawal.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add withdrawal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding withdrawal: $e');
    }
  }

  // Get all withdrawals
  Future<List<Withdrawal>> getWithdrawals() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/withdraw'));

      if (response.statusCode == 200) {
        List<dynamic> withdrawalsJson = jsonDecode(response.body);
        return withdrawalsJson.map((json) => Withdrawal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load withdrawals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching withdrawals: $e');
    }
  }
}