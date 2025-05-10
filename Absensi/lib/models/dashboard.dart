// lib/models/dashboard.dart
class Dashboard {
  final int totalUser;
  final int totalSiswa;
  final int totalGuru;
  final int totalAbsensiHariIni;

  Dashboard({
    required this.totalUser,
    required this.totalSiswa,
    required this.totalGuru,
    required this.totalAbsensiHariIni,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalUser: (json['totalUser'] as int?) ?? 0,
      totalSiswa: (json['totalSiswa'] as int?) ?? 0,
      totalGuru: (json['totalGuru'] as int?) ?? 0,
      totalAbsensiHariIni: (json['totalAbsensiHariIni'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalUser': totalUser,
    'totalSiswa': totalSiswa,
    'totalGuru': totalGuru,
    'totalAbsensiHariIni': totalAbsensiHariIni,
  };
}
