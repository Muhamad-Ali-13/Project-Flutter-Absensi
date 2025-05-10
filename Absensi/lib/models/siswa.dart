class Siswa {
  final int idSiswa;
  final int idUsers;
  final String nis;
  final DateTime tanggalLahir;
  final String alamat;
  final String noHp;
  final int id_kelas;
  final String jenisKelamin;

  Siswa({
    required this.idSiswa,
    required this.idUsers,
    required this.nis,
    required this.tanggalLahir,
    required this.alamat,
    required this.noHp,
    required this.id_kelas,
    required this.jenisKelamin,
  });

  factory Siswa.fromJson(Map<String, dynamic> json) => Siswa(
    idSiswa: json['id_siswa'],
    idUsers: json['id_users'],
    nis: json['nis'],
    tanggalLahir: DateTime.parse(json['tanggal_lahir']),
    alamat: json['alamat'] ?? '',
    noHp: json['no_hp'] ?? '',
    id_kelas: json['id_kelas'],
    jenisKelamin: json['jenis_kelamin'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id_siswa': idSiswa,
    'id_users': idUsers,
    'nis': nis,
    'tanggal_lahir': tanggalLahir.toIso8601String(),
    'alamat': alamat,
    'no_hp': noHp,
    'id_kelas': id_kelas,
    'jenis_kelamin': jenisKelamin,
  };
}
