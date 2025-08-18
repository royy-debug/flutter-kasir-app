import 'package:flutter/material.dart';
import 'package:kasir_flutter_app/mobile/utils/constants.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_list_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/obat_form_screen.dart';
import 'package:kasir_flutter_app/mobile/screens/auth_screen.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ Tambah package chart

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

      // ✅ Drawer (Hamburger Menu)
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
                    MaterialPageRoute(builder: (_) => ObatListScreen()));
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

      // ✅ Body diisi Chart
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '📊 Laporan Penjualan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const SalesChart(),
          const SizedBox(height: 24),
          const Text(
            '🥇 Produk Terlaris',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const TopProductChart(),
        ],
      ),
    );
  }
}

//
// ✅ Widget Chart Penjualan (Bar Chart)
//
class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: true),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(toY: 5, color: AppColors.primary),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(toY: 3, color: AppColors.primary),
                ]),
                BarChartGroupData(x: 2, barRods: [
                  BarChartRodData(toY: 7, color: AppColors.primary),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ✅ Widget Produk Terlaris (Pie Chart)
//
class TopProductChart extends StatelessWidget {
  const TopProductChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 40,
                  title: 'Obat A',
                  color: Colors.blue,
                ),
                PieChartSectionData(
                  value: 30,
                  title: 'Obat B',
                  color: Colors.green,
                ),
                PieChartSectionData(
                  value: 20,
                  title: 'Obat C',
                  color: Colors.orange,
                ),
                PieChartSectionData(
                  value: 10,
                  title: 'Obat D',
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
