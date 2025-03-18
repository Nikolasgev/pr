import '../../../catalog/domain/entities/product.dart';

class Order {
  final String id;
  final String clientName;
  final String address;
  final String phone;
  final String email;
  final String comments;
  final List<Product> products;
  final String status;

  Order({
    required this.id,
    required this.clientName,
    required this.address,
    required this.phone,
    required this.email,
    required this.comments,
    required this.products,
    required this.status,
  });
}
