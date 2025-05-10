class Absensi {
  final int id;
  final int idSiswa;
  final int idJadwal;
  final DateTime tanggal;
  final DateTime jamMasuk;
  final DateTime jamKeluar;
  final String status;
  final String? fotoAbsensi;
  final String keterangan;

  Absensi({
    required this.id,
    required this.idSiswa,
    required this.idJadwal,
    required this.tanggal,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.status,
    this.fotoAbsensi,
    required this.keterangan,
  });

  factory Absensi.fromJson(Map<String, dynamic> json) {
    return Absensi(
      id: json['id'],
      idSiswa: json['id_siswa'],
      idJadwal: json['id_jadwal'],
      tanggal: DateTime.parse(json['tanggal']),
      jamMasuk: DateTime.parse('1970-01-01T${json['jam_masuk']}'),
      jamKeluar: DateTime.parse('1970-01-01T${json['jam_keluar']}'),
      status: json['status'],
      fotoAbsensi: json['foto_absensi'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_siswa': idSiswa,
      'id_jadwal': idJadwal,
      'tanggal': tanggal.toIso8601String().split('T').first,
      'jam_masuk': jamMasuk.toIso8601String().split('T')[1].substring(0, 8),
      'jam_keluar': jamKeluar.toIso8601String().split('T')[1].substring(0, 8),
      'status': status,
      'keterangan': keterangan,
    };
  }
}
