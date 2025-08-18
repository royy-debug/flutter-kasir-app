import 'dart:io' show File; // hanya untuk mobile
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? _imageFile;
  Uint8List? _webImage; // untuk web
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // web pakai bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = pickedFile;
        });
      } else {
        // mobile pakai file path
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text("Pilih Gambar"),
        ),
        const SizedBox(height: 20),
        if (_imageFile != null)
          kIsWeb
              ? (_webImage != null
                  ? Image.memory(_webImage!, width: 200, height: 200, fit: BoxFit.cover)
                  : const Text("Gagal memuat gambar"))
              : (_imageFile!.path.isNotEmpty
                  ? Image.file(File(_imageFile!.path), width: 200, height: 200, fit: BoxFit.cover)
                  : const Text("Path gambar kosong"))
        else
          const Text("Belum ada gambar"),
      ],
    );
  }
}
