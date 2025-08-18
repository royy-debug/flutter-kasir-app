class Sale {
  final int saleId;
  final int userId;
  final int? customerId;
  final DateTime saleDate;
  final double total;
  final double payment;
  final double changeAmount;

  const Sale({
    required this.saleId,
    required this.userId,
    this.customerId,
    required this.saleDate,
    required this.total,
    required this.payment,
    required this.changeAmount,
  });

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        saleId: json['sale_id'] as int,
        userId: json['user_id'] as int,
        customerId: json['customer_id'] as int?,
        saleDate: DateTime.parse(json['sale_date'] as String),
        total: double.parse(json['total'].toString()),
        payment: double.parse(json['payment'].toString()),
        changeAmount: double.parse(json['change'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'sale_id': saleId,
        'user_id': userId,
        'customer_id': customerId,
        'sale_date': saleDate.toIso8601String(),
        'total': total,
        'payment': payment,
        'change': changeAmount,
      };
}