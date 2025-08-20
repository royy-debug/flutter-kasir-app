import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import '../services/obat_service.dart';
import 'detail_pembayaran_screen.dart';

class PembayaranScreen extends StatefulWidget {
  final Map<Obat, int> cart;

  const PembayaranScreen({super.key, required this.cart});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final _service = ObatService();
  String _metodePembayaran = "Cash";

  double get totalHarga => widget.cart.entries.fold(
        0,
        (sum, entry) => sum + (entry.key.harga * entry.value),
      );

Future<void> _prosesPembayaran() async {
  try {
    for (var entry in widget.cart.entries) {
      final obat = entry.key;
      final jumlah = entry.value;

      // Ambil stok terbaru dari Firebase
      final stokTerbaru = await _service.getStokById(obat.id!);

      if (stokTerbaru >= jumlah) {
        final stokBaru = stokTerbaru - jumlah;
        await _service.updateStok(obat.id!, stokBaru);
      } else {
        // stok tidak cukup, batal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Stok ${obat.nama} tidak mencukupi")),
        );
        return; // hentikan proses pembayaran
      }
    }

    // pindah ke detail struk
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPembayaranScreen(
          cart: widget.cart,
          totalHarga: totalHarga,
          metode: _metodePembayaran,
        ),
      ),
    );

    // hapus keranjang di ObatListScreen
    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pembayaran gagal: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: widget.cart.entries.map((entry) {
                  final obat = entry.key;
                  final jumlah = entry.value;
                  return ListTile(
                    title: Text(obat.nama),
                    subtitle: Text("Jumlah: $jumlah x Rp${obat.harga}"),
                    trailing: Text("Rp ${obat.harga * jumlah}"),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text("Rp $totalHarga",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _metodePembayaran,
              items: const [
                DropdownMenuItem(value: "Cash", child: Text("Cash")),
                DropdownMenuItem(value: "Non-Cash", child: Text("Non-Cash (Transfer, e-Wallet)")),
              ],
              onChanged: (val) => setState(() => _metodePembayaran = val!),
              decoration: const InputDecoration(
                labelText: "Metode Pembayaran",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _prosesPembayaran,
              icon: const Icon(Icons.check),
              label: const Text("Bayar Sekarang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
