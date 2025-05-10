class Kelas {
  final int idKelas;
  final String namaKelas;
  final int? idGuru;

  Kelas({
    required this.idKelas,
    required this.namaKelas,
    this.idGuru,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      idKelas: json['id_kelas'] as int,
      namaKelas: json['nama_kelas'] as String,
      idGuru: json['id_guru'] != null ? json['id_guru'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kelas': idKelas,
      'nama_kelas': namaKelas,
      'id_guru': idGuru,
    };
  }
}
