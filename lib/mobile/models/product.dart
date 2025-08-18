class Product {
  final int productId;
  final String name;
  final String barcode;
  final int categoryId;
  final double price;
  final int stock;
  final DateTime createdAt;

  const Product({
    required this.productId,
    required this.name,
    required this.barcode,
    required this.categoryId,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['product_id'] as int,
        name: json['name'] as String,
        barcode: json['barcode'] as String,
        categoryId: json['category_id'] as int,
        price: double.parse(json['price'].toString()),
        stock: json['stock'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'name': name,
        'barcode': barcode,
        'category_id': categoryId,
        'price': price,
        'stock': stock,
        'created_at': createdAt.toIso8601String(),
      };
}