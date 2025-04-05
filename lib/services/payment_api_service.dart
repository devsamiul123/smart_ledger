import 'dart:convert';
import 'package:http/http.dart' as http;

class Payment {
  final int? id;
  final String orderId;
  final double paidAmount;
  final String paymentType;
  final String paymentAccount;
  final String paidDate;

  Payment({
    this.id,
    required this.orderId,
    required this.paidAmount,
    required this.paymentType,
    required this.paymentAccount,
    required this.paidDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['order_id'],
      paidAmount: double.parse(json['paid_amount'].toString()),
      paymentType: json['payment_type'],
      paymentAccount: json['payment_account'],
      paidDate: json['paid_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'paid_amount': paidAmount,
      'payment_type': paymentType,
      'payment_account': paymentAccount,
      'paid_date': paidDate,
    };
  }
}

class PaymentApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client = http.Client();

  // Add a new payment
  Future<Map<String, dynamic>> addPayment(Payment payment) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payment.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to add payment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding payment: $e');
    }
  }

  // Get all payments
  Future<List<Payment>> getPayments() async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/payment'));

      if (response.statusCode == 200) {
        List<dynamic> paymentsJson = jsonDecode(response.body);
        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }
}