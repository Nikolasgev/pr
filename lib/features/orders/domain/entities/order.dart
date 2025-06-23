import '../../../cart/domain/entities/cart_item.dart';

class Order {
  final String id;
  final String clientName;
  final String address;
  final String phone;
  final String email;
  final String comments;
  final List<CartItem> items;
  final String status;
  final String? telegramUserId;
  final String? telegramUsername;
  final double price;

  Order({
    required this.id,
    required this.clientName,
    required this.address,
    required this.phone,
    required this.email,
    required this.comments,
    required this.items,
    required this.status,
    this.telegramUserId,
    this.telegramUsername,
    required this.price,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      clientName: json['clientName'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      comments: json['comments'] ?? '',
      status: json['status'] ?? '',
      price: (json['price'] ?? 0).toDouble(), // ← добавь
      telegramUserId: json['telegramUserId'],
      telegramUsername: json['telegramUsername'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'address': address,
      'phone': phone,
      'email': email,
      'comments': comments,
      'status': status,
      'price': price, // ← добавь
      'telegramUserId': telegramUserId,
      'telegramUsername': telegramUsername,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
