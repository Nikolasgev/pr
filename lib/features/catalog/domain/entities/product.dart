class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;

  /// карта «объём → цена»
  final Map<String, double> prices;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.prices,
  });

  /// список доступных объёмов
  List<String> get volumes => prices.keys.toList();

  /// цена конкретного объёма
  double priceFor(String vol) => prices[vol] ?? 0;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        category: json['category'] ?? '',
        prices: (json['prices'] as Map).map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
        'prices': prices,
      };
}
