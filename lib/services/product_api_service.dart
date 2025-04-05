import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String productName;
  final double unitPrice;
  final String unitType;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.productName,
    required this.unitPrice,
    required this.unitType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      unitPrice: json['unit_price'].toDouble(),
      unitType: json['unit_type'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ProductApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final http.Client client = http.Client();

  // Create - Add new product
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> productData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/product'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add product: ${response.statusCode}');
    }
  }

  // Read - Get all products
  Future<List<Product>> getAllProducts() async {
    final response = await client.get(Uri.parse('$baseUrl/product'));

    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Read - Get single product
  Future<Product> getProduct(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/product/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  // Update - Update existing product
  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await client.put(
      Uri.parse('$baseUrl/product/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(productData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  // Delete - Delete product
  Future<void> deleteProduct(int id) async {
    final response = await client.delete(Uri.parse('$baseUrl/product/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}