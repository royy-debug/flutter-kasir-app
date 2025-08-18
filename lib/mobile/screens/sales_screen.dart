import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data keranjang
    final cartItems = [
      {"name": "Kopi Hitam", "qty": 2, "price": 15000.0},
      {"name": "Teh Botol", "qty": 1, "price": 5000.0},
    ];

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + ((item["price"] as double) * (item["qty"] as int)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Penjualan")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            child: ListTile(
              title: Text(item["name"] as String),
              subtitle: Text("Qty: ${item["qty"]}"),
              trailing: Text(Formatter.money(item["price"] as double)),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(Formatter.money(total),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lanjut ke pembayaran")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: const StadiumBorder(),
                ),
                child: const Text("Continue to Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
