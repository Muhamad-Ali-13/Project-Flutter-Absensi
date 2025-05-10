class JadwalPembelajaran {
  final int idJadwal;
  final int idGuru;
  final int idKelas;
  final int idMapel;
  final String hari;
  final String jamMulai;   // format "HH:MM:SS"
  final String jamSelesai; // format "HH:MM:SS"

  JadwalPembelajaran({
    required this.idJadwal,
    required this.idGuru,
    required this.idKelas,
    required this.idMapel,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });

  factory JadwalPembelajaran.fromJson(Map<String, dynamic> json) {
    return JadwalPembelajaran(
      idJadwal: json['id_jadwal'],
      idGuru: json['id_guru'],
      idKelas: json['id_kelas'],
      idMapel: json['id_mapel'],
      hari: json['hari'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jadwal': idJadwal,
      'id_guru': idGuru,
      'id_kelas': idKelas,
      'id_mapel': idMapel,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
    };
  }
}
