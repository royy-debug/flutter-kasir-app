import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import '../services/obat_service.dart';

class PembayaranScreen extends StatefulWidget {
  final Map<Obat, int> cart;

  const PembayaranScreen({super.key, required this.cart});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  late Map<Obat, int> _cart;
  final ObatService _service = ObatService(); // service Firebase

  @override
  void initState() {
    super.initState();
    // clone cart agar bisa edit tanpa merusak data asli
    _cart = Map.from(widget.cart);
  }

  double get totalHarga {
    double total = 0;
    _cart.forEach((obat, qty) {
      total += obat.harga * qty;
    });
    return total;
  }

  void _hapusItem(Obat obat) {
    setState(() {
      _cart.remove(obat);
    });
  }

  void _selesaikanPesanan() {
    // TODO: simpan transaksi ke Firestore kalau mau
    // karena transaksi berhasil → stok tidak dikembalikan
    Navigator.pop(context, true); 
  }

  void _batalPesanan() {
    // kembalikan stok sebelum keluar
    _cart.forEach((obat, qty) {
      obat.stok += qty;
      _service.updateStok(obat.id!, obat.stok); // balikin ke Firebase
    });

    Navigator.pop(context, false); // kirim sinyal batal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.blue,
      ),
      body: _cart.isEmpty
          ? const Center(child: Text("Tidak ada pesanan"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final obat = _cart.keys.elementAt(index);
                      final qty = _cart[obat]!;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: obat.foto.isNotEmpty
                              ? Image.network(obat.foto, width: 50)
                              : const Icon(Icons.medical_services),
                          title: Text(obat.nama),
                          subtitle: Text(
                              "Rp ${obat.harga} x $qty = Rp ${obat.harga * qty}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _hapusItem(obat),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Rp $totalHarga",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _batalPesanan,
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text("Batalkan"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _selesaikanPesanan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text("Selesaikan"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
