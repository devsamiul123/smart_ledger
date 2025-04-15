import 'dart:convert';
import 'package:http/http.dart' as http;

class Customer {
  final int id;
  final String customer_name;
  final String mobile_no;
  final String? email;
  final String? address;
  final String? tin_bin_nid;
  final String? tin_bin_nid_type;
  final String createdAt;
  final String updatedAt;

  Customer({
    required this.id,
    required this.customer_name,
    required this.mobile_no,
    this.email,
    this.address,
    this.tin_bin_nid,
    this.tin_bin_nid_type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      customer_name: json['customer_name'],
      mobile_no: json['mobile_no'],
      email: json['email'],
      address: json['address'],
      tin_bin_nid: json['tin_bin_nid'],
      tin_bin_nid_type: json['tin_bin_nid_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class CustomerApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client = http.Client();

  // Create - Add new customer
  Future<Map<String, dynamic>> addCustomer(Map<String, dynamic> customerData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/customer'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customerData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add customer: ${response.statusCode}');
    }
  }

  // Read - Get all customers
  Future<List<Customer>> getAllCustomers() async {
    final response = await client.get(Uri.parse('$baseUrl/customer'));

    if (response.statusCode == 200) {
      List<dynamic> customersJson = jsonDecode(response.body);
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode}');
    }
  }

  // Read - Get single customer
  Future<Customer> getCustomer(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/customer/$id'));

    if (response.statusCode == 200) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load customer: ${response.statusCode}');
    }
  }

  // Update - Update existing customer
  Future<Map<String, dynamic>> updateCustomer(int id, Map<String, dynamic> customerData) async {
    final response = await client.put(
      Uri.parse('$baseUrl/customer/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customerData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update customer: ${response.statusCode}');
    }
  }

  // Delete - Delete customer
  Future<void> deleteCustomer(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/customer/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete customer: ${response.statusCode}');
    }
  }
}