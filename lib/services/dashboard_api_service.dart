// services/dashboard_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticsReport {
  final int totalOrder;
  final int totalRevenue;
  final int totalPayment;
  final int totalDues;
  final int totalExpense;
  final int totalWithdraw;
  final int totalCashInHand;

  StatisticsReport({
    required this.totalOrder,
    required this.totalRevenue,
    required this.totalPayment,
    required this.totalDues,
    required this.totalExpense,
    required this.totalWithdraw,
    required this.totalCashInHand,
  });

  factory StatisticsReport.fromJson(Map<String, dynamic> json) {
    return StatisticsReport(
      totalOrder: json['totalOrder'],
      totalRevenue: json['totalRevenue'],
      totalPayment: json['totalPayment'],
      totalDues: json['totalDues'],
      totalExpense: json['totalExpense'],
      totalWithdraw: json['totalWithdraw'],
      totalCashInHand: json['totalCashInHand'],
    );
  }
}

class OrderItem {
  final int productId;
  final int qty;
  final int unitInNumber;
  final String unitInString;

  OrderItem({
    required this.productId,
    required this.qty,
    required this.unitInNumber,
    required this.unitInString,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'qty': qty,
      'unit_in_number': unitInNumber,
      'unit_in_string': unitInString,
    };
  }
}

class Order {
  final int customerId;
  final String orderPlacingDate;
  final List<OrderItem> items;

  Order({
    required this.customerId,
    required this.orderPlacingDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'order_placing_date': orderPlacingDate,
      'child': items.map((item) => {
        'order_id': 1, // This would typically be generated on the server
        'product_id': item.productId,
        'qty': item.qty,
        'unit_in_number': item.unitInNumber,
        'unit_in_string': item.unitInString,
      }).toList(),
    };
  }
}

class DashboardApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<StatisticsReport> getStatisticsReport() async {
    final response = await http.get(Uri.parse('$baseUrl/statistics_report'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return StatisticsReport.fromJson(data);
    } else {
      throw Exception('Failed to load statistics report. Status code: ${response.statusCode}');
    }
  }

  Future<bool> placeOrder(Order order) async {
    final response = await http.post(
      Uri.parse('$baseUrl/placing_order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to place order. Status code: ${response.statusCode}');
    }
  }
}