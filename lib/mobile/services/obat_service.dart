import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/obat_detail.dart';

class ObatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ✅ Tipkan koleksi agar doc.data() -> Map<String, dynamic>?
  CollectionReference<Map<String, dynamic>> get _obatCollection =>
_firestore.collection('obat');

  // Stream list obat
  Stream<List<Obat>> getObatList() {
    return _obatCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Obat.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  // Tambah obat + upload gambar
  Future<void> tambahObat(Obat obat, {File? imageFile}) async {
    String fotoUrl = '';
    if (imageFile != null) {
      final ref = _storage
          .ref()
          .child('obat/${obat.nama}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      fotoUrl = await ref.getDownloadURL();
    }

    await _obatCollection.add({
      'nama': obat.nama,
      'kategori': obat.kategori,
      'stok': obat.stok,
      'harga': obat.harga,
      'foto': fotoUrl,
    });
  }

  // Update obat + (opsional) ganti gambar
  Future<void> updateObat(String id, Obat obat, {File? imageFile}) async {
    String fotoUrl = obat.foto;

    if (imageFile != null) {
      final ref = _storage
          .ref()
          .child('obat/${obat.nama}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      fotoUrl = await ref.getDownloadURL();
    }

    await _obatCollection.doc(id).update({
      'nama': obat.nama,
      'kategori': obat.kategori,
      'stok': obat.stok,
      'harga': obat.harga,
      'foto': fotoUrl,
    });
  }

  // Hapus obat + (jika ada) hapus file foto di Storage
  Future<void> hapusObat(String id) async {
    final doc = await _obatCollection.doc(id).get();
    if (doc.exists) {
      final data = doc.data(); // Map<String, dynamic>?
      final fotoUrl = (data?['foto'] as String?) ?? '';
      if (fotoUrl.isNotEmpty) {
        try {
          final ref = _storage.refFromURL(fotoUrl);
          await ref.delete();
        } catch (_) {
          // abaikan jika file sudah tidak ada
        }
      }
      await _obatCollection.doc(id).delete();
    }
  }

  // ✅ Ambil stok terbaru (cast aman)
  Future<int> getStokById(String id) async {
    final doc = await _obatCollection.doc(id).get();
    final data = doc.data(); // Map<String, dynamic>?
    // stok bisa tersimpan sebagai int/double -> pakai num lalu toInt()
    final stok = (data?['stok'] as num?)?.toInt() ?? 0;
    return stok;
  }

  // ✅ Update stok langsung
  Future<void> updateStok(String id, int stokBaru) async {
    await _obatCollection.doc(id).update({'stok': stokBaru});
  }

  // // 🔒 (Opsional) Kurangi stok secara atomik pakai transaction
  // Future<void> decrementStokAtomic(String id, int jumlah) async {
  //   await _firestore.runTransaction((tx) async {
  //     final ref = _obatCollection.doc(id);
  //     final snap = await tx.get(ref);
  //     if (!snap.exists) throw Exception('Obat tidak ditemukan');
  //     final data = snap.data()!;
  //     final stok = (data['stok'] as num?)?.toInt() ?? 0;
  //     if (stok < jumlah) {
  //       throw Exception('Stok tidak mencukupi');
  //     }
  //     tx.update(ref, {'stok': stok - jumlah});
  //   });
  // }
}
