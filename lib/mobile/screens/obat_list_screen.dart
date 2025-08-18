import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import '../services/obat_service.dart';
import 'obat_form_screen.dart';
import 'pembayaran_screen.dart'; // Tambahkan screen pembayaran baru

class ObatListScreen extends StatefulWidget {
  const ObatListScreen({super.key});

  @override
  State<ObatListScreen> createState() => _ObatListScreenState();
}

class _ObatListScreenState extends State<ObatListScreen> {
  final ObatService _service = ObatService();
  final List<Obat> _selectedObat = []; // simpan obat yang dipilih

  void _toggleSelectObat(Obat obat) {
    setState(() {
      if (_selectedObat.contains(obat)) {
        _selectedObat.remove(obat);
      } else {
        _selectedObat.add(obat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Obat")),
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
              childAspectRatio: 0.7,
            ),
            itemCount: obatList.length,
            itemBuilder: (context, index) {
              final obat = obatList[index];
              final isSelected = _selectedObat.contains(obat);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ObatFormScreen(obat: obat),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar obat
                      Expanded(
                        child: obat.foto.isNotEmpty
                            ? Image.network(
                                obat.foto,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.medical_services,
                                      size: 50, color: Colors.grey),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              obat.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text("Kategori: ${obat.kategori}",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600])),
                            Text("Stok: ${obat.stok}",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600])),
                            const SizedBox(height: 6),
                            Text(
                              "Rp ${obat.harga}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tombol Beli / Selected
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ElevatedButton(
                            onPressed: () => _toggleSelectObat(obat),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.green : Colors.blue,
                              minimumSize: const Size(80, 35),
                            ),
                            child: Text(
                              isSelected ? "Dipilih" : "Beli",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: _selectedObat.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PembayaranScreen(obatDipilih: _selectedObat),
                  ),
                );
              },
              icon: const Icon(Icons.payment),
              label: Text("Bayar (${_selectedObat.length})"),
            )
          : null,
    );
  }
}
