class Obat {
  String id;
  String nama;
  String kategori;
  int stok;
  double harga;
  String foto; // URL gambar

  Obat({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.harga,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'kategori': kategori,
      'stok': stok,
      'harga': harga,
      'foto': foto,
    };
  }

  factory Obat.fromMap(Map<String, dynamic> map, String documentId) {
    return Obat(
      id: documentId,
      nama: map['nama'] ?? '',
      kategori: map['kategori'] ?? '',
      stok: map['stok'] ?? 0,
      harga: (map['harga'] ?? 0).toDouble(),
      foto: map['foto'] ?? '',
    );
  }

  get jumlah => null;
}
