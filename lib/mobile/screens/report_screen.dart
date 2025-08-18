// import 'package:flutter/material.dart';
// import '../widgets/app_bar.dart';
// import '../services/api_service.dart';
// import '../utils/formatter.dart';

// class ReportScreen extends StatefulWidget {
//   static const routeName = '/reports';
//   const ReportScreen({super.key});

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final _api = ApiService();

//   @override
//   Widget build(BuildContext context) {
//     final totalPenjualan = _api.sales.fold<double>(0, (sum, s) => sum + s.total);
//     final totalTransaksi = _api.sales.length;
//     return Scaffold(
//       appBar: CustomAppBar(titleText: 'Laporan Ringkas'),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Wrap(
//               spacing: 12, runSpacing: 12,
//               children: [
//                 _StatCard(title: 'Total Penjualan', value: Formatter.money(totalPenjualan)),
//                 _StatCard(title: 'Jumlah Transaksi', value: '$totalTransaksi'),
//                 _StatCard(title: 'Produk Terdaftar', value: '${_api.products.length}'),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text('Catatan: data ini dari mock service. Integrasikan ke backend untuk data real-time.'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   const _StatCard({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 240,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//               const SizedBox(height: 8),
//               Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }