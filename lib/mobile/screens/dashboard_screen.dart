import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasir_flutter_app/mobile/utils/constants.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_list_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_form_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/auth_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Ambil jumlah penjualan per obat
  Future<Map<String, int>> _getObatCount() async {
    final penjualanSnap =
        await FirebaseFirestore.instance.collection('penjualan').get();

    Map<String, int> obatCount = {};

    for (var doc in penjualanSnap.docs) {
      final data = doc.data();
      final items = data['items'] as List<dynamic>? ?? [];

      for (var item in items) {
        final String obatId = item['obatId'] ?? '';
        final int jumlah = item['jumlah'] ?? 0;

        // ambil nama obat dari koleksi obat
        final obatSnap = await FirebaseFirestore.instance
            .collection('obat')
            .doc(obatId)
            .get();

        final namaObat = obatSnap.data()?['nama'] ?? 'Unknown';

        obatCount[namaObat] = (obatCount[namaObat] ?? 0) + jumlah;
      }
    }

    return obatCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Produk'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ObatListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Tambah Produk'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ObatFormScreen()));
              },
            ),
          ],
        ),
      ),

      // FutureBuilder untuk mengambil data obat
      body: FutureBuilder<Map<String, int>>(
        future: _getObatCount(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error saat mengambil data: ${snapshot.error}'));
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final obatCount = snapshot.data ?? {};
          final obatList = obatCount.keys.toList();
          final jumlahList = obatCount.values.toList();

          if (obatCount.isEmpty) {
            return const Center(child: Text("Belum ada data penjualan"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '📊 Laporan Penjualan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SalesChart(obatList: obatList, jumlahList: jumlahList),
              const SizedBox(height: 24),
              const Text(
                '🥇 Produk Terlaris',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TopProductChart(obatCount: obatCount),
            ],
          );
        },
      ),
    );
  }
}

// Bar Chart
class SalesChart extends StatelessWidget {
  final List<String> obatList;
  final List<int> jumlahList;

  const SalesChart(
      {super.key, required this.obatList, required this.jumlahList});

  @override
  Widget build(BuildContext context) {
    if (obatList.isEmpty) {
      return const Center(child: Text("Belum ada data penjualan"));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < obatList.length) {
                        return Text(
                          obatList[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              barGroups: List.generate(obatList.length, (index) {
                return BarChartGroupData(x: index, barRods: [
                  BarChartRodData(
                    toY: jumlahList[index].toDouble(),
                    color: AppColors.primary,
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  )
                ]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// Pie Chart
class TopProductChart extends StatelessWidget {
  final Map<String, int> obatCount;

  const TopProductChart({super.key, required this.obatCount});

  @override
  Widget build(BuildContext context) {
    if (obatCount.isEmpty) {
      return const Center(child: Text("Belum ada data penjualan"));
    }

    final total = obatCount.values.fold<int>(0, (a, b) => a + b);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: obatCount.entries.map((e) {
                final persen = (e.value / total * 100).toStringAsFixed(1);
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: '${e.key}\n$persen%',
                  radius: 60,
                  color: Colors.primaries[
                      obatCount.keys.toList().indexOf(e.key) %
                          Colors.primaries.length],
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
