import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import '../services/obat_service.dart';
import 'obat_form_screen.dart';
import 'pembayaran_screen.dart';

class ObatListScreen extends StatefulWidget {
  const ObatListScreen({super.key});

  @override
  State<ObatListScreen> createState() => _ObatListScreenState();
}

class _ObatListScreenState extends State<ObatListScreen> {
  final _service = ObatService();
  final Map<Obat, int> _cart = {}; // Obat + jumlah di keranjang

  void _tambahObat(Obat obat) {
    if (obat.stok > (_cart[obat] ?? 0)) {
      setState(() => _cart[obat] = (_cart[obat] ?? 0) + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok tidak mencukupi")),
      );
    }
  }

  void _kurangiObat(Obat obat) {
    if ((_cart[obat] ?? 0) > 0) {
      setState(() {
        _cart[obat] = _cart[obat]! - 1;
        if (_cart[obat] == 0) _cart.remove(obat);
      });
    }
  }

  void _batalPesanan() {
    setState(() => _cart.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pesanan dibatalkan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Obat"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ObatFormScreen()),
            ),
          ),
          if (_cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: _batalPesanan,
            ),
        ],
      ),
      body: StreamBuilder<List<Obat>>(
        stream: _service.getObatList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final obatList = snapshot.data!;
          if (obatList.isEmpty) {
            return const Center(child: Text("Belum ada data obat"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: obatList.length,
            itemBuilder: (_, i) {
              final obat = obatList[i];
              final jumlahDipilih = _cart[obat] ?? 0;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Karena foto tidak dipakai, langsung tampilkan ikon default
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: const Center(
                              child: Icon(Icons.medical_services, size: 50, color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.black87),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ObatFormScreen(obat: obat)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(obat.nama,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Kategori: ${obat.kategori}",
                              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          Text("Stok: ${obat.stok}",
                              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          const SizedBox(height: 6),
                          Text("Rp ${obat.harga}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: jumlahDipilih == 0
                            ? ElevatedButton(
                                key: const ValueKey("TambahBtn"),
                                onPressed: () => _tambahObat(obat),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text("Tambah"),
                              )
                            : Row(
                                key: const ValueKey("CounterRow"),
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => _kurangiObat(obat),
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  ),
                                  Text("$jumlahDipilih",
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    onPressed: () => _tambahObat(obat),
                                    icon: const Icon(Icons.add_circle, color: Colors.green),
                                  ),
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PembayaranScreen(cart: _cart)),
                );

                if (result == true) setState(() => _cart.clear());
              },
              icon: const Icon(Icons.payment),
              label: Text("Bayar (${_cart.length})"),
            )
          : null,
    );
  }
}
