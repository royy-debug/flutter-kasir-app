import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import 'pembayaran_detail_screen.dart';
class PembayaranScreen extends StatelessWidget {
  final List<Obat> obatDipilih;

  const PembayaranScreen({super.key, required this.obatDipilih});

  @override
  Widget build(BuildContext context) {
    final totalHarga = obatDipilih.fold<double>(
      0,
      (sum, item) => sum + item.harga,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: obatDipilih.length,
                itemBuilder: (context, index) {
                  final obat = obatDipilih[index];
                  return ListTile(
                    leading: obat.foto.isNotEmpty
                        ? Image.network(obat.foto, width: 50, fit: BoxFit.cover)
                        : const Icon(Icons.medical_services),
                    title: Text(obat.nama),
                    trailing: Text("Rp ${obat.harga}"),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total:",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Rp $totalHarga",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Setelah bayar, redirect ke detail pembayaran
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPembayaranScreen(
                      obatDipilih: obatDipilih,
                      totalHarga: totalHarga,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text("Bayar Sekarang"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
