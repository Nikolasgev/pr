import '../../../cart/domain/entities/cart_item.dart';

class Order {
  final String id;
  final String clientName;
  final String address;
  final String phone;
  final String email;
  final String comments;
  final List<CartItem> items; // изменили с List<Product> на List<CartItem>
  final String status;
  final String? telegramUserId; // новое поле для Telegram ID
  final String? telegramUsername; // новое поле для Telegram username

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
  });
}
