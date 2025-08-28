import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_flutter_app/mobile/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sales_chart.dart';
import '../widgets/top_product_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Stream<Map<String, int>> _getObatCountStream() async* {
    final obatCache = <String, String>{};

    await for (var penjualanSnap
        in FirebaseFirestore.instance.collection('penjualan').snapshots()) {
      Map<String, int> obatCount = {};

      for (var doc in penjualanSnap.docs) {
        final data = doc.data();
        final items = data['items'] as List<dynamic>? ?? [];

        for (var item in items) {
          final String obatId = item['obatId'] ?? '';
          final int jumlah = item['jumlah'] ?? 0;

          if (obatId.isEmpty) continue;

          if (!obatCache.containsKey(obatId)) {
            try {
              final obatSnap = await FirebaseFirestore.instance
                  .collection('obat')
                  .doc(obatId)
                  .get();

              if (obatSnap.exists) {
                obatCache[obatId] = obatSnap.data()?['nama'] ?? 'Unknown';
              } else {
                obatCache[obatId] = 'Unknown';
              }
            } catch (_) {
              obatCache[obatId] = 'Unknown';
            }
          }

          final namaObat = obatCache[obatId]!;
          obatCount[namaObat] = (obatCount[namaObat] ?? 0) + jumlah;
        }
      }

      yield obatCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, int>>(
      stream: _getObatCountStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('⚠️ Terjadi error saat mengambil data'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final obatCount = snapshot.data ?? {};
        final obatList = obatCount.keys.toList();
        final jumlahList = obatCount.values.toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📊 Laporan Penjualan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              obatCount.isEmpty
                  ? const Text("Belum ada data penjualan")
                  : SalesChart(obatList: obatList, jumlahList: jumlahList),

              const SizedBox(height: 24),

              const Text(
                '🥇 Produk Terlaris',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              obatCount.isEmpty
                  ? const Text("Belum ada data penjualan")
                  : TopProductChart(obatCount: obatCount),
            ],
          ),
        );
      },
    );
  }
}
