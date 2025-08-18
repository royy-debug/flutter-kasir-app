import 'package:flutter/material.dart';
import '../models/obat_detail.dart';
import '../services/obat_service.dart';
import 'obat_form_screen.dart';

class ObatListScreen extends StatelessWidget {
  final ObatService _service = ObatService();

  ObatListScreen({super.key});

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
              crossAxisCount: 2, // 2 kolom
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7, // tinggi card lebih panjang
            ),
            itemCount: obatList.length,
            itemBuilder: (context, index) {
              final obat = obatList[index];
              return GestureDetector(
                onTap: () {
                  // Aksi kalau card diklik -> bisa detail/edit
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
                            Text(
                              "Kategori: ${obat.kategori}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Stok: ${obat.stok}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
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
                      // Tombol edit/hapus di pojok kanan bawah
                      Align(
                        alignment: Alignment.bottomRight,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ObatFormScreen(obat: obat)),
                              );
                            } else if (value == 'hapus') {
                              _service.hapusObat(obat.id!);
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'edit', child: Text("Edit")),
                            const PopupMenuItem(
                                value: 'hapus', child: Text("Hapus")),
                          ],
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ObatFormScreen()),
          );
        },
      ),
    );
  }
}
