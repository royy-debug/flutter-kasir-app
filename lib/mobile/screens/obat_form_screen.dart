import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/obat_detail.dart';
import 'package:path/path.dart' as p;

import '../services/obat_service.dart';

class ObatFormScreen extends StatefulWidget {
  final Obat? obat;
  const ObatFormScreen({super.key, this.obat});

  @override
  State<ObatFormScreen> createState() => _ObatFormScreenState();
}

class _ObatFormScreenState extends State<ObatFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ObatService();

  late TextEditingController _namaCtrl;
  late TextEditingController _kategoriCtrl;
  late TextEditingController _stokCtrl;
  late TextEditingController _hargaCtrl;

  File? _imageFile; // untuk foto baru
  String? _fotoUrl; // untuk foto lama / hasil upload

  @override
  void initState() {
    super.initState();
    _namaCtrl = TextEditingController(text: widget.obat?.nama ?? '');
    _kategoriCtrl = TextEditingController(text: widget.obat?.kategori ?? '');
    _stokCtrl = TextEditingController(text: widget.obat?.stok?.toString() ?? '');
    _hargaCtrl = TextEditingController(text: widget.obat?.harga?.toString() ?? '');

    // simpan url foto lama jika ada
    _fotoUrl = widget.obat?.foto ?? '';
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _kategoriCtrl.dispose();
    _stokCtrl.dispose();
    _hargaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // simpan foto baru
      });
    }
  }

  Future<String?> uploadGambar(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.4/apotek/upload.php'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto',
          imageFile.path,
          filename: p.basename(imageFile.path),
        ),
      );

      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      final result = jsonDecode(respStr);

      if (result['status'] == true) return result['url'];
    } catch (e) {
      print('Upload Error: $e');
    }
    return null;
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      String? fotoUrl = _fotoUrl; // default dari foto lama

      // jika pilih foto baru → upload dulu
      if (_imageFile != null) {
        final uploadedUrl = await uploadGambar(_imageFile!);
        if (uploadedUrl != null) fotoUrl = uploadedUrl;
      }

      final obat = Obat(
        nama: _namaCtrl.text,
        kategori: _kategoriCtrl.text,
        stok: int.tryParse(_stokCtrl.text) ?? 0,
        harga: double.tryParse(_hargaCtrl.text) ?? 0.0,
        foto: fotoUrl ?? '', id: '',
      );

      if (widget.obat == null) {
        await _service.tambahObat(obat);
      } else {
        await _service.updateObat(widget.obat!.id!, obat);
      }

      if (mounted) Navigator.pop(context); // HAPUS casting yg salah
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.obat == null ? "Tambah Obat" : "Edit Obat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    // preview foto baru
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    // jika tidak ada foto baru, tampilkan foto lama (jika ada)
                    : (_fotoUrl != null && _fotoUrl!.isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _fotoUrl!,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                            ),
                          )
                        // fallback kalau foto kosong
                        : Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300],
                            ),
                            child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: "Nama Obat"),
                validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _kategoriCtrl,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stokCtrl,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hargaCtrl,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveData,
                icon: const Icon(Icons.save),
                label: const Text("Simpan", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
