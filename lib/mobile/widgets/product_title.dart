import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';

class ProductTile extends StatelessWidget {
  final String name;
  final double price;
  final int stock;
  final VoidCallback onAdd;

  const ProductTile({
    super.key,
    required this.name,
    required this.price,
    required this.stock,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bannerBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.inventory_2_outlined,
                      size: 40, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              Formatter.money(price),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            Text(
              "Stok: $stock",
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
