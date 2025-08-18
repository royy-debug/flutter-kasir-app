class Customer {
  final int customerId;
  final String name;
  final String? phone;
  final String? address;

  const Customer({
    required this.customerId,
    required this.name,
    this.phone,
    this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json['customer_id'] as int,
        name: json['name'] as String,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'name': name,
        'phone': phone,
        'address': address,
      };
}