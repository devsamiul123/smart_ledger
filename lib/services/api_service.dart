import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_ledger/models/order_model.dart';

class ApiService {
  // Don't include the protocol in _baseUrl when using Uri.http()
  static const String _baseUrl = '10.0.2.2:8000';
  static const String _apiPath = 'api';

  // Fetch orders from API
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.http(_baseUrl, '/$_apiPath/placing_order'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(response.body);
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Add new customer
  Future<void> addCustomer(String customerName, String mobileNo) async {
    try {
      final response = await http.post(
        Uri.http(_baseUrl, '/$_apiPath/customer'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'customer_name': customerName,
          'mobile_no': mobileNo,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}