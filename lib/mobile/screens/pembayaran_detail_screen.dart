import 'package:flutter/material.dart';
import '../models/obat_detail.dart';

class DetailPembayaranScreen extends StatelessWidget {
  final List<Obat> obatDipilih;
  final double totalHarga;

  const DetailPembayaranScreen({
    super.key,
    required this.obatDipilih,
    required this.totalHarga,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pembayaran")),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                // TODO: Cetak struk (misalnya generate PDF atau print)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Struk dicetak!")),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text("Cetak Struk"),
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
