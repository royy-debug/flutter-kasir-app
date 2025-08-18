import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/search_field.dart';
import '../widgets/product_title.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = TextEditingController();

    // Data dummy untuk contoh
    final products = [
      {"name": "Kopi Hitam", "price": 15000.0, "stock": 20},
      {"name": "Teh Botol", "price": 5000.0, "stock": 50},
      {"name": "Gula Pasir", "price": 12000.0, "stock": 15},
      {"name": "Susu UHT", "price": 14000.0, "stock": 30},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RoundedSearchField(controller: searchCtrl, hint: "Cari produk..."),
            AppGaps.lg,
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return ProductTile(
                    name: p["name"] as String,
                    price: p["price"] as double,
                    stock: p["stock"] as int,
                    onAdd: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${p["name"]} ditambahkan!")),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
