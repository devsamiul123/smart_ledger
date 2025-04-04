class Order {
  final int id;
  final int customerId;
  final double totalPrice;
  final String orderPlacingDate;
  final String createdAt;
  final String updatedAt;
  final List<OrderItem> child;

  Order({
    required this.id,
    required this.customerId,
    required this.totalPrice,
    required this.orderPlacingDate,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      orderPlacingDate: json['order_placing_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      child: (json['child'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int qty;
  final int unitInNumber;
  final String unitInString;
  final double? itemPrice;
  final String createdAt;
  final String updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.qty,
    required this.unitInNumber,
    required this.unitInString,
    this.itemPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      qty: json['qty'],
      unitInNumber: json['unit_in_number'],
      unitInString: json['unit_in_string'] ?? '',
      itemPrice: json['item_price'] != null ? (json['item_price']).toDouble() : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}