import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class SaleDetailScreen extends StatelessWidget {
  static const routeName = '/sale-detail';
  const SaleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Detail Penjualan'),
      body: const Center(child: Text('Detail penjualan akan ditampilkan di sini.')),
    );
  }
}