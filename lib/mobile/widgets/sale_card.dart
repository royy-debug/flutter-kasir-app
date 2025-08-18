import 'package:flutter/material.dart';
import '../utils/formatter.dart';

class SaleCard extends StatelessWidget {
  final int saleId;
  final DateTime date;
  final double total;
  final VoidCallback? onTap;

  const SaleCard({
    super.key,
    required this.saleId,
    required this.date,
    required this.total,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Transaksi #$saleId'),
        subtitle: Text(Formatter.dateTime(date)),
        trailing: Text(Formatter.money(total)),
        onTap: onTap,
      ),
    );
  }
}