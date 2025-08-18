import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/obat_detail.dart';

class ObatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Ambil list obat sebagai stream
  Stream<List<Obat>> getObatList() {
    return _firestore.collection('obat').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Obat.fromMap(doc.data(), doc.id)).toList());
  }

  // Tambah obat dengan upload gambar
  Future<void> tambahObat(Obat obat, {File? imageFile}) async {
    String fotoUrl = '';
    if (imageFile != null) {
      final ref = _storage.ref().child('obat/${obat.nama}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      fotoUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('obat').add({
      'nama': obat.nama,
      'kategori': obat.kategori,
      'stok': obat.stok,
      'harga': obat.harga,
      'foto': fotoUrl,
    });
  }

  // Update obat
  Future<void> updateObat(String id, Obat obat, {File? imageFile}) async {
    String fotoUrl = obat.foto;

    if (imageFile != null) {
      final ref = _storage.ref().child('obat/${obat.nama}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      fotoUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('obat').doc(id).update({
      'nama': obat.nama,
      'kategori': obat.kategori,
      'stok': obat.stok,
      'harga': obat.harga,
      'foto': fotoUrl,
    });
  }

  // Hapus obat
  Future<void> hapusObat(String id) async {
    final doc = await _firestore.collection('obat').doc(id).get();
    if (doc.exists && doc.data()?['foto'] != null && doc.data()?['foto'] != '') {
      try {
        final ref = _storage.refFromURL(doc.data()!['foto']);
        await ref.delete();
      } catch (_) {}
    }
    await _firestore.collection('obat').doc(id).delete();
  }
}
