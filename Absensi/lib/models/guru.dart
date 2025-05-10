class Guru {
  final int idGuru;
  final int idUsers;
  final String nip;
  final String jenisKelamin;
  final String? noHp;

  Guru({
    required this.idGuru,
    required this.idUsers,
    required this.nip,
    required this.jenisKelamin,
    this.noHp,
  });

  factory Guru.fromRow(List<dynamic> row) {
    return Guru(
      idGuru: row[0] as int,
      idUsers: row[1] as int,
      nip: row[2] as String,
      jenisKelamin: row[3] as String,
      noHp: row[4] as String?,
    );
  }

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      idGuru: json['id_guru'] as int,
      idUsers: json['id_users'] as int,
      nip: json['nip'] as String,
      jenisKelamin: json['jenis_kelamin'] as String,
      noHp: json['no_hp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_guru': idGuru,
      'id_users': idUsers,
      'nip': nip,
      'jenis_kelamin': jenisKelamin,
      'no_hp': noHp,
    };
  }
}
